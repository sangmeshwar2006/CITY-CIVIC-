const Complaint = require("../models/Complaint");
const uploadImage = require("../utils/uploadImage");

const createComplaint = async (req, res, next) => {
  try {
    const { title, description, category, lat, lng, address } = req.body;

    if (!title || !description || lat === undefined || lat === "" || lng === undefined || lng === "") {
      return res.status(400).json({ message: "Missing required fields" });
    }

    const imageUrl = await uploadImage(req.file);

    const complaint = await Complaint.create({
      title,
      description,
      category,
      imageUrl,
      location: {
        lat: Number(lat),
        lng: Number(lng),
        address: address || "Mock civic location",
      },
      createdBy: req.user._id,
      history: [{ status: "Pending", note: "Complaint submitted" }],
    });

    const populatedComplaint = await complaint.populate("createdBy", "name email");
    res.status(201).json(populatedComplaint);
  } catch (error) {
    next(error);
  }
};

const getComplaints = async (req, res, next) => {
  try {
    const { status, category } = req.query;
    const query = {};

    if (status) {
      query.status = status;
    }

    if (category) {
      query.category = category;
    }

    if (req.user.role !== "admin") {
      query.createdBy = req.user._id;
    }

    const complaints = await Complaint.find(query)
      .populate("createdBy", "name email")
      .sort({ createdAt: -1 });

    res.json(complaints);
  } catch (error) {
    next(error);
  }
};

const getComplaintById = async (req, res, next) => {
  try {
    const complaint = await Complaint.findById(req.params.id).populate(
      "createdBy",
      "name email"
    );

    if (!complaint) {
      return res.status(404).json({ message: "Complaint not found" });
    }

    const isOwner = complaint.createdBy._id.toString() === req.user._id.toString();
    if (req.user.role !== "admin" && !isOwner) {
      return res.status(403).json({ message: "Access denied" });
    }

    res.json(complaint);
  } catch (error) {
    next(error);
  }
};

const updateComplaintStatus = async (req, res, next) => {
  try {
    const { status, note } = req.body;
    const complaint = await Complaint.findById(req.params.id);

    if (!complaint) {
      return res.status(404).json({ message: "Complaint not found" });
    }

    complaint.status = status || complaint.status;
    complaint.history.push({
      status: complaint.status,
      note: note || `Status updated to ${complaint.status}`,
    });

    await complaint.save();
    const populatedComplaint = await complaint.populate("createdBy", "name email");

    res.json(populatedComplaint);
  } catch (error) {
    next(error);
  }
};

const deleteComplaint = async (req, res, next) => {
  try {
    const complaint = await Complaint.findById(req.params.id);

    if (!complaint) {
      return res.status(404).json({ message: "Complaint not found" });
    }

    await complaint.deleteOne();
    res.json({ message: "Complaint deleted" });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  createComplaint,
  getComplaints,
  getComplaintById,
  updateComplaintStatus,
  deleteComplaint,
};

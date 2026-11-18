const Complaint = require("../models/Complaint");

const getComplaintStats = async (_req, res, next) => {
  try {
    const byCategory = await Complaint.aggregate([
      { $group: { _id: "$category", count: { $sum: 1 } } },
      { $sort: { count: -1 } },
    ]);

    const byStatus = await Complaint.aggregate([
      { $group: { _id: "$status", count: { $sum: 1 } } },
      { $sort: { count: -1 } },
    ]);

    res.json({ byCategory, byStatus });
  } catch (error) {
    next(error);
  }
};

module.exports = { getComplaintStats };

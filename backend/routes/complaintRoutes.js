const express = require("express");
const {
  createComplaint,
  getComplaints,
  getComplaintById,
  updateComplaintStatus,
  deleteComplaint,
} = require("../controllers/complaintController");
const { protect, adminOnly } = require("../middleware/authMiddleware");
const upload = require("../middleware/uploadMiddleware");

const router = express.Router();

router.use(protect);
router.route("/").post(upload.single("image"), createComplaint).get(getComplaints);
router.route("/:id").get(getComplaintById).put(adminOnly, updateComplaintStatus).delete(adminOnly, deleteComplaint);

module.exports = router;

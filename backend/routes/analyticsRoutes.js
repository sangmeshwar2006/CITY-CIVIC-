const express = require("express");
const { getComplaintStats } = require("../controllers/analyticsController");
const { protect, adminOnly } = require("../middleware/authMiddleware");

const router = express.Router();

router.get("/", protect, adminOnly, getComplaintStats);

module.exports = router;

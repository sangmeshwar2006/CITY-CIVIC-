const dotenv = require("dotenv");
const connectDatabase = require("./config/db");
const User = require("./models/User");
const Complaint = require("./models/Complaint");

dotenv.config();

const run = async () => {
  await connectDatabase();

  await Complaint.deleteMany();
  await User.deleteMany();

  const admin = await User.create({
    name: "Admin User",
    email: "admin@citycivic.com",
    password: "Admin@123",
    role: "admin",
  });

  const citizen = await User.create({
    name: "Rahul Sharma",
    email: "user@citycivic.com",
    password: "User@123",
    role: "user",
  });

  await Complaint.insertMany([
    {
      title: "Overflowing garbage bin near market",
      description: "Waste has not been collected for two days and the smell is strong.",
      category: "Garbage",
      imageUrl: "",
      location: { lat: 12.9716, lng: 77.5946, address: "Market Road Ward 4" },
      status: "Pending",
      createdBy: citizen._id,
      history: [{ status: "Pending", note: "Complaint submitted by citizen" }],
    },
    {
      title: "Pothole causing traffic slowdown",
      description: "Large pothole at the signal is dangerous for bikes and cars.",
      category: "Road",
      imageUrl: "",
      location: { lat: 12.9732, lng: 77.601, address: "Central Signal Junction" },
      status: "In Progress",
      createdBy: citizen._id,
      history: [
        { status: "Pending", note: "Complaint submitted by citizen" },
        { status: "In Progress", note: "Maintenance team assigned" },
      ],
    },
  ]);

  console.log("Seed data created");
  console.log("Admin: admin@citycivic.com / Admin@123");
  console.log("User: user@citycivic.com / User@123");
  process.exit(0);
};

run().catch((error) => {
  console.error(error);
  process.exit(1);
});

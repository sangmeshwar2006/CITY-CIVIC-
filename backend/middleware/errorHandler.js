const errorHandler = (err, _req, res, _next) => {
  console.error(err);

  if (err.name === "ValidationError") {
    return res.status(400).json({ message: err.message });
  }

  if (err.code === 11000) {
    return res.status(400).json({ message: "Email already exists" });
  }

  res.status(err.statusCode || 500).json({
    message: err.message || "Server error",
  });
};

module.exports = errorHandler;

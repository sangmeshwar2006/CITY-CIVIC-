const path = require("path");
const { cloudinary, isCloudinaryConfigured } = require("../config/cloudinary");

const uploadImage = async (file) => {
  if (!file) {
    return "";
  }

  if (isCloudinaryConfigured()) {
    const result = await cloudinary.uploader.upload(file.path, {
      folder: "city-civic",
    });
    return result.secure_url;
  }

  return `/uploads/${path.basename(file.path)}`;
};

module.exports = uploadImage;

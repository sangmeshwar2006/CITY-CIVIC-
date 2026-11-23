const test = require("node:test");
const assert = require("node:assert/strict");
const generateToken = require("../utils/generateToken");
const errorHandler = require("../middleware/errorHandler");

test("City Civic Backend Unit Test Suite", async (t) => {
  // Silence console.error for clean test output
  const originalConsoleError = console.error;
  t.before(() => {
    console.error = () => {};
  });
  t.after(() => {
    console.error = originalConsoleError;
  });

  await t.test("generateToken produces a valid JWT format", () => {
    process.env.JWT_SECRET = "test-jwt-secret-key-12345";
    const sampleUserId = "673f1a2b3c4d5e6f7a8b9c0d";
    const token = generateToken(sampleUserId);

    assert.equal(typeof token, "string", "Token must be a string");
    assert.ok(token.length > 20, "Token should be of reasonable JWT length");
    const parts = token.split(".");
    assert.equal(parts.length, 3, "JWT must consist of three dot-separated segments");
  });

  await t.test("errorHandler formats default 500 internal server error", () => {
    const mockError = new Error("Unexpected database failure");
    let responseStatus = null;
    let responseBody = null;

    const mockRes = {
      status(code) {
        responseStatus = code;
        return this;
      },
      json(data) {
        responseBody = data;
        return this;
      },
    };

    errorHandler(mockError, {}, mockRes, () => {});

    assert.equal(responseStatus, 500, "Default status code must be 500");
    assert.equal(responseBody.message, "Unexpected database failure");
  });

  await t.test("errorHandler handles Mongoose ValidationError with 400", () => {
    const mockError = new Error("Category is required");
    mockError.name = "ValidationError";
    let responseStatus = null;
    let responseBody = null;

    const mockRes = {
      status(code) {
        responseStatus = code;
        return this;
      },
      json(data) {
        responseBody = data;
        return this;
      },
    };

    errorHandler(mockError, {}, mockRes, () => {});

    assert.equal(responseStatus, 400, "Validation errors should return 400");
    assert.equal(responseBody.message, "Category is required");
  });

  await t.test("errorHandler respects custom err.statusCode", () => {
    const mockError = new Error("Invalid credentials");
    mockError.statusCode = 401;
    let responseStatus = null;
    let responseBody = null;

    const mockRes = {
      status(code) {
        responseStatus = code;
        return this;
      },
      json(data) {
        responseBody = data;
        return this;
      },
    };

    errorHandler(mockError, {}, mockRes, () => {});

    assert.equal(responseStatus, 401, "Status code must match err.statusCode");
    assert.equal(responseBody.message, "Invalid credentials");
  });
});

/**
 * Lightweight in-memory sliding-window rate limiter
 * Protects endpoints from brute-force attacks and abuse without external Redis dependencies.
 */

const createRateLimiter = ({
  windowMs = 15 * 60 * 1000, // 15 minutes default
  max = 100, // Max requests per windowMs
  message = "Too many requests from this IP, please try again later.",
} = {}) => {
  const requests = new Map();

  // Periodic cleanup of stale records every 5 minutes
  setInterval(() => {
    const now = Date.now();
    for (const [ip, data] of requests.entries()) {
      if (now - data.startTime > windowMs) {
        requests.delete(ip);
      }
    }
  }, 5 * 60 * 1000).unref();

  return (req, res, next) => {
    const ip =
      req.ip ||
      req.headers["x-forwarded-for"]?.split(",")[0]?.trim() ||
      req.socket.remoteAddress ||
      "unknown";

    const now = Date.now();
    const clientData = requests.get(ip);

    if (!clientData || now - clientData.startTime > windowMs) {
      requests.set(ip, { count: 1, startTime: now });
      res.setHeader("X-RateLimit-Limit", max);
      res.setHeader("X-RateLimit-Remaining", max - 1);
      return next();
    }

    clientData.count += 1;
    const remaining = Math.max(0, max - clientData.count);
    res.setHeader("X-RateLimit-Limit", max);
    res.setHeader("X-RateLimit-Remaining", remaining);

    if (clientData.count > max) {
      const retryAfterSeconds = Math.ceil(
        (clientData.startTime + windowMs - now) / 1000
      );
      res.setHeader("Retry-After", retryAfterSeconds);
      return res.status(429).json({
        message,
        retryAfter: retryAfterSeconds,
      });
    }

    next();
  };
};

// Specialized limiters for City Civic
const authLimiter = createRateLimiter({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 10, // Max 10 login / register attempts per 15 minutes
  message: "Too many authentication attempts, please try again in 15 minutes.",
});

const apiLimiter = createRateLimiter({
  windowMs: 15 * 60 * 1000,
  max: 150, // 150 requests per 15 minutes for standard API calls
  message: "API rate limit exceeded. Please slow down your requests.",
});

module.exports = {
  createRateLimiter,
  authLimiter,
  apiLimiter,
};

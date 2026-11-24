# City Civic — Environment Variables Reference

This document details all environment variables used across the **City Civic** ecosystem, their expected formats, defaults, and security recommendations.

---

## 1. Backend API (`backend/.env`)

| Variable | Required | Default | Description | Example |
| :--- | :--- | :--- | :--- | :--- |
| `PORT` | No | `5000` | HTTP port Express listens on | `5000` |
| `MONGODB_URI` | **Yes** | `mongodb://127.0.0.1:27017/city-civic` | MongoDB connection URI string | `mongodb+srv://user:pass@cluster.mongodb.net/city-civic` |
| `JWT_SECRET` | **Yes** | — | Cryptographic secret for signing auth JWTs | `a9f8b4...64-char-hex-string` |
| `CLIENT_URL` | No | `*` | Allowed CORS origins (comma-separated for multiple) | `http://localhost:5173,https://admin.citycivic.org` |
| `CLOUDINARY_CLOUD_NAME` | No | `""` | Cloudinary account name for cloud media storage | `my-civic-cloud` |
| `CLOUDINARY_API_KEY` | No | `""` | Cloudinary API Key | `123456789012345` |
| `CLOUDINARY_API_SECRET` | No | `""` | Cloudinary API Secret | `abcdefghijklmnopqrstuv_1234` |
| `NODE_ENV` | No | `development` | Runtime environment (`development`, `production`, `test`) | `production` |

> [!NOTE]
> If Cloudinary credentials are omitted, uploaded complaint images are automatically persisted to the local directory `backend/uploads/`.

---

## 2. Admin Dashboard (`admin/.env`)

Vite requires client-exposed environment variables to start with the `VITE_` prefix:

| Variable | Required | Default | Description | Example |
| :--- | :--- | :--- | :--- | :--- |
| `VITE_API_BASE_URL` | **Yes** | `http://localhost:5000/api` | Backend REST API endpoint reachable by browser | `https://api.citycivic.org/api` |

---

## 3. Docker Compose (`.env`)

When deploying via `docker-compose.yml`, the compose file sets sensible defaults across services. You can override them in a root `.env` file:

```bash
# Docker Compose Overrides
PORT=5000
MONGODB_URI=mongodb://mongodb:27017/city-civic
JWT_SECRET=production-secret-must-be-changed
CLIENT_URL=http://localhost:5173
VITE_API_BASE_URL=http://localhost:5000/api
```

---

## 4. Security Checklist for Production

- [ ] **Generate High-Entropy JWT Secret**: Use a secure random string (at least 32 bytes):
  ```bash
  node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
  ```
- [ ] **Restrict CORS**: Always set `CLIENT_URL` explicitly to your production frontend domain (never leave as `*`).
- [ ] **Database Connection Security**: Enforce TLS (`ssl=true`) and strict authentication on MongoDB Atlas.
- [ ] **Never Commit `.env` Files**: Verify that all `.env` files remain ignored in `.gitignore`.

# City Civic — Production Deployment Guide

This guide describes how to deploy the City Civic backend API, React administration dashboard, and MongoDB database into production environments.

---

## 1. Architecture Checklist

| Layer | Recommended Host | Production Solution |
| :--- | :--- | :--- |
| **Database** | MongoDB Atlas | M0 / M10 Dedicated Replica Set |
| **Media Storage** | Cloudinary | CDN-backed image asset delivery |
| **Backend API** | Render / Railway / VPS | Node.js (Docker container or systemd PM2) |
| **Admin Dashboard** | Vercel / Netlify / Nginx | Static SPA hosting with HTTPS |
| **Mobile App** | Google Play / App Store | Flutter Release Bundle (.aab / .ipa) |

---

## 2. Setting Up Cloud Services

### 2.1 MongoDB Atlas
1. Create a free M0 or production cluster on [MongoDB Atlas](https://www.mongodb.com/cloud/atlas).
2. Create a database user with read/write privileges.
3. Under **Network Access**, whitelist your server's IP address (or `0.0.0.0/0` with secure credentials).
4. Copy the connection string:
   ```
   mongodb+srv://<username>:<password>@cluster0.mongodb.net/city-civic?retryWrites=true&w=majority
   ```

### 2.2 Cloudinary (Image Uploads)
1. Register for an account on [Cloudinary](https://cloudinary.com/).
2. Obtain your **Cloud Name**, **API Key**, and **API Secret** from the dashboard.
3. Add these credentials to your backend environment configuration.

---

## 3. Backend Deployment

### Option A: Deploy via Docker (Recommended)
1. Build the production image:
   ```bash
   cd backend
   docker build -t city-civic-backend:latest .
   ```
2. Run the container with environment variables:
   ```bash
   docker run -d \
     --name city-civic-backend \
     -p 5000:5000 \
     -e PORT=5000 \
     -e MONGODB_URI="mongodb+srv://..." \
     -e JWT_SECRET="your-256bit-random-secret" \
     -e CLIENT_URL="https://admin.yourdomain.com" \
     -e CLOUDINARY_CLOUD_NAME="your_cloud_name" \
     -e CLOUDINARY_API_KEY="your_api_key" \
     -e CLOUDINARY_API_SECRET="your_api_secret" \
     city-civic-backend:latest
   ```

### Option B: Deploy on VPS with PM2 & Nginx
1. SSH into your Ubuntu/Debian server.
2. Install Node.js 18+ and PM2:
   ```bash
   npm install -g pm2
   ```
3. Clone and configure:
   ```bash
   git clone https://github.com/sangmeshwar2006/CITY-CIVIC-.git
   cd CITY-CIVIC-/backend
   cp .env.example .env
   # Update .env with production credentials
   npm install --production
   pm2 start server.js --name "city-civic-api"
   pm2 save
   pm2 startup
   ```

---

## 4. Admin Dashboard Deployment

### Option A: Vercel / Netlify
1. Connect your GitHub repository to Vercel or Netlify.
2. Set **Root Directory** to `admin`.
3. Set **Build Command** to `npm run build`.
4. Set **Output Directory** to `dist`.
5. Add Environment Variable:
   - `VITE_API_BASE_URL`: `https://api.yourdomain.com/api`

### Option B: Docker with Nginx
1. Build the multi-stage image:
   ```bash
   cd admin
   docker build -t city-civic-admin:latest .
   ```
2. Run container:
   ```bash
   docker run -d -p 80:80 --name city-civic-admin city-civic-admin:latest
   ```

---

## 5. Flutter Mobile App Release

### Android APK / App Bundle
1. Navigate to the mobile app directory:
   ```bash
   cd flutter_app
   ```
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Build release bundle:
   ```bash
   flutter build appbundle --release
   ```
4. Output file: `build/app/outputs/bundle/release/app-release.aab`

---

## 6. Security & SSL Configuration

1. **Enforce HTTPS**: Use Let's Encrypt (Certbot) on your reverse proxy for all domains.
2. **CORS Configuration**: Restrict `CLIENT_URL` in `backend/.env` strictly to your production admin domain.
3. **JWT Expiration**: Configure sensible token expiration in `backend/utils/generateToken.js`.

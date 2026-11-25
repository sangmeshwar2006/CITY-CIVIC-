# City Civic — Troubleshooting & FAQ Guide

This guide covers common development, deployment, database, and mobile environment issues with verified solutions.

---

## 1. Backend & Database Issues

### Error: `MongooseServerSelectionError: connect ECONNREFUSED 127.0.0.1:27017`
- **Cause**: Local MongoDB service is stopped or not listening on port 27017.
- **Solution**:
  - If using Docker: run `docker-compose up -d mongodb`.
  - If using Windows Service: open Services (`services.msc`), find **MongoDB Server**, and click **Start**.
  - If using MongoDB Atlas: verify your connection string in `backend/.env` has `mongodb+srv://` and that your current public IP is added to Atlas **Network Access**.

---

### Error: `Error: secretOrPrivateKey must have a value`
- **Cause**: `JWT_SECRET` is missing in `backend/.env`.
- **Solution**:
  - Open `backend/.env` (or copy from `backend/.env.example`).
  - Add a secure string: `JWT_SECRET=your_super_secret_key_12345`.

---

### Error: `ENOENT: no such file or directory, open '.../uploads/...'`
- **Cause**: The `backend/uploads` directory does not exist when Cloudinary is not configured.
- **Solution**:
  - The repository includes `backend/uploads/.gitkeep` to ensure the folder is tracked.
  - If missing locally, create it: `mkdir backend/uploads`.

---

## 2. Admin Dashboard Issues

### Error: `Cross-Origin Request Blocked (CORS)`
- **Cause**: The backend's `CLIENT_URL` does not include the URL of the Admin panel.
- **Solution**:
  - In `backend/.env`, set:
    ```env
    CLIENT_URL=http://localhost:5173,http://localhost:3000
    ```
  - Restart the backend: `npm run dev`.

---

### Error: `Failed to load resource: net::ERR_CONNECTION_REFUSED (VITE_API_BASE_URL)`
- **Cause**: Admin dashboard is making requests to `http://localhost:5000/api` while the backend is not running or running on another port.
- **Solution**:
  - Ensure backend is running: `cd backend && npm run dev`.
  - In `admin/.env`, verify `VITE_API_BASE_URL=http://localhost:5000/api`.

---

## 3. Flutter Mobile App Issues

### Error: `SocketException: Connection refused (OS Error: Connection refused, errno = 111)`
- **Cause**: Connecting to `localhost` inside an Android emulator attempts to connect to the emulator itself rather than your host machine.
- **Solution**:
  - In `flutter_app/lib/services/api_client.dart`:
    - **Android Emulator**: Use `http://10.0.2.2:5000/api`.
    - **iOS Simulator**: Use `http://127.0.0.1:5000/api`.
    - **Physical Device**: Use your computer's local Wi-Fi IP (e.g. `http://192.168.1.50:5000/api`).

---

### Error: `MissingPluginException(No implementation found for method ... image_picker)`
- **Cause**: Native dependencies were not linked after adding Flutter plugins.
- **Solution**:
  - Stop the running Flutter session (`q` in terminal).
  - Run:
    ```bash
    cd flutter_app
    flutter clean
    flutter pub get
    flutter run
    ```

---

## 4. Docker & Port Issues

### Error: `Error starting userland proxy: listen tcp4 0.0.0.0:5000: bind: address already in use`
- **Cause**: Another process (like a local Node server) is already using port 5000.
- **Solution**:
  - On Windows PowerShell, find and kill the process:
    ```powershell
    Get-Process -Id (Get-NetTCPConnection -LocalPort 5000).OwningProcess | Stop-Process -Force
    ```
  - Then run `docker-compose up -d`.

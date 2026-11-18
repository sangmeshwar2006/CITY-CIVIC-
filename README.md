# City Civic App

Full-stack civic issue reporting system with:

- `backend/`: Node.js + Express + MongoDB REST API
- `admin/`: React + Vite admin dashboard
- `flutter_app/`: Flutter mobile app for citizens

## 1. Backend setup

Copy `backend/.env.example` to `backend/.env` and update values.

```bash
cd backend
npm install
npm run seed
npm run dev
```

Important notes:

- `npm run seed` creates:
- Admin: `admin@citycivic.com` / `Admin@123`
- User: `user@citycivic.com` / `User@123`
- If Cloudinary credentials are missing, uploaded images are stored locally in `backend/uploads/`.

## 2. Admin panel setup

Copy `admin/.env.example` to `admin/.env`.

```bash
cd admin
npm install
npm run dev
```

Admin panel features:

- Admin login
- Complaint table with category and status filters
- Status update dropdown
- Delete complaint action
- Basic analytics cards

## 3. Flutter app setup

```bash
cd flutter_app
flutter pub get
flutter run
```

Flutter notes:

- Android emulator uses `http://10.0.2.2:5000/api` in `lib/services/api_client.dart`
- For a physical device or iOS simulator, update `baseUrl` to your machine IP
- Location is mocked through `LocationService`
- Camera and gallery use `image_picker`

## 4. Core API endpoints

- `POST /api/auth/register`
- `POST /api/auth/login`
- `POST /api/complaints`
- `GET /api/complaints`
- `GET /api/complaints/:id`
- `PUT /api/complaints/:id`
- `DELETE /api/complaints/:id`
- `GET /api/analytics`

## 5. Project structure

```text
backend/
  config/
  controllers/
  middleware/
  models/
  routes/
  utils/
admin/
  src/components/
  src/context/
  src/pages/
  src/services/
flutter_app/lib/
  models/
  screens/
  services/
  widgets/
  utils/
```

## 6. Bonus coverage

- Basic analytics by category and status
- Cloudinary-ready image upload integration
- Local upload fallback for easy local testing

## 7. Next upgrades

- Firebase Cloud Messaging push notifications
- Real GPS permissions via `geolocator`
- Map preview with Google Maps Flutter
- Pagination and search for large complaint volumes

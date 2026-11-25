# City Civic — Flutter Mobile Application Guide

This handbook covers development, device networking, geolocation setup, and build procedures for the **City Civic** Flutter mobile application (`flutter_app/`).

---

## 1. Project Structure

```
flutter_app/
├── lib/
│   ├── main.dart               # App entry point, Provider setup, Theme
│   ├── models/                 # Data entities (Complaint)
│   ├── screens/                # User UI (Home, Login, Signup, AddComplaint, Detail)
│   ├── services/               # HTTP client, Auth, Complaints, Geolocation
│   ├── utils/                  # Input validation helpers
│   └── widgets/                # Reusable UI components (Chips, Cards, Timeline)
├── test/                       # Automated widget and unit tests
└── pubspec.yaml                # Dependencies and asset declarations
```

---

## 2. Connecting to Backend During Development

When testing on different devices, the API URL in `lib/services/api_client.dart` must point to your host computer:

| Environment | Host IP | Full API Endpoint |
| :--- | :--- | :--- |
| **Android Emulator** | `10.0.2.2` | `http://10.0.2.2:5000/api` |
| **iOS Simulator** | `127.0.0.1` | `http://127.0.0.1:5000/api` |
| **Physical Android/iOS Device** | LAN IP (e.g. `192.168.1.15`) | `http://192.168.1.15:5000/api` |
| **Production Server** | Domain | `https://api.citycivic.org/api` |

> [!TIP]
> Ensure your mobile device and development machine are connected to the same Wi-Fi network when testing on a physical phone.

---

## 3. Platform Permissions

### Android (`android/app/src/main/AndroidManifest.xml`)
The citizen application requires camera, gallery, and fine location access to submit complaints:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Internet & Network Access -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

    <!-- Geolocation Permissions -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

    <!-- Photo Evidence Permissions -->
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
</manifest>
```

### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>City Civic requires location access to tag civic complaints accurately.</string>
<key>NSCameraUsageDescription</key>
<string>City Civic needs camera access to capture photographic evidence of civic issues.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>City Civic needs photo gallery access to upload pictures of civic problems.</string>
```

---

## 4. Running and Testing

### Fetch Dependencies
```bash
cd flutter_app
flutter pub get
```

### Run Tests
```bash
flutter test
```

### Launch Debug Session
```bash
flutter run
```

---

## 5. Production Release Compilation

### Build Android App Bundle (Google Play Store)
```bash
flutter build appbundle --release
```
*Output location*: `build/app/outputs/bundle/release/app-release.aab`

### Build Android APK (Direct Sideloading)
```bash
flutter build apk --release
```
*Output location*: `build/app/outputs/flutter-apk/app-release.apk`

# City Civic — Testing & Quality Assurance Guide

This handbook outlines the automated and manual testing methodologies used across the **City Civic** ecosystem.

---

## 1. Test Architecture Overview

```
+-------------------------------------------------------------+
|                      Test Pyramid                           |
|                                                             |
|                    /   E2E Tests   \                        |
|                   /  (Manual & CI)  \                       |
|                  /-------------------\                      |
|                 /  Integration Tests  \                     |
|                /   (API Route Mocks)   \                    |
|               /-------------------------\                   |
|              /      Unit & Widget Tests  \                  |
|             / (Node Native / Flutter Test) \                |
+-------------------------------------------------------------+
```

---

## 2. Backend Automated Testing

The backend uses Node.js's built-in test runner (`node:test` and `node:assert`), requiring zero third-party testing dependencies.

### Running Backend Tests

Navigate to `backend/` and run:

```bash
cd backend
node --test tests/api.test.js
```

### What Backend Tests Cover
- **Token Generation**: Validates HMAC-SHA256 JWT construction, entropy, and segmentation.
- **Error Handling Middleware**: Tests 400, 401, 404, and 500 status code routing and JSON serialization.
- **Route Validation**: Syntax checks on controller and route definitions.

---

## 3. Flutter Mobile App Testing

The Flutter citizen mobile app utilizes the official `flutter_test` package.

### Running Flutter Tests

Navigate to `flutter_app/` and run:

```bash
cd flutter_app
flutter test
```

### What Flutter Tests Cover
- **App Smoke Test**: Verifies root `MaterialApp` instantiation, theme color palette, and scaffold layout.
- **Widget Triage**: Tests interactive state changes on complaint category chips and status indicators.
- **Form Validation**: Tests email, password, and coordinate string validators (`validators.dart`).

---

## 4. Admin Dashboard Testing

The Admin Dashboard (React + Vite) is verified through syntax integrity and production bundling checks:

```bash
cd admin
npm run build
```

This verifies:
- JSX syntax validation across all pages (`DashboardPage`, `AdminPreviewPage`, `LoginPage`).
- Vite bundle optimization and asset resolution.
- CSS module compatibility.

---

## 5. Continuous Integration (CI)

Every pull request and push to `main` automatically runs our GitHub Actions CI pipeline (`.github/workflows/ci.yml`):

1. **Backend Check**: Installs dependencies and verifies `server.js` compilation via `node --check`.
2. **Admin Build**: Builds production static assets to guarantee zero bundle breakages.

---

## 6. Pre-Commit Checklist

Before submitting code:
- [ ] Run backend tests: `cd backend && node --test tests/api.test.js`
- [ ] Build admin dashboard: `cd admin && npm run build`
- [ ] Ensure no credentials or `.env` files are tracked: `git status`

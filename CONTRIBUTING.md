# Contributing to City Civic

Thank you for your interest in contributing to **City Civic**! City Civic is an open-source civic issue reporting and resolution system designed for citizens and municipal administrators.

---

## Architecture Overview

The repository is organized as a monorepo containing three core components:

- **`backend/`**: Node.js, Express, MongoDB REST API for user authentication, complaint filing, category tagging, and admin analytics.
- **`admin/`**: React + Vite admin dashboard for complaint triage, status updates, and civic analytics.
- **`flutter_app/`**: Flutter mobile application for citizens to submit and track complaints with geolocation and photos.

---

## Getting Started

### Prerequisites

Ensure you have the following installed locally:
- [Node.js](https://nodejs.org/) (v18.x or newer) and `npm`
- [MongoDB](https://www.mongodb.com/) (running locally or via Docker)
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (for mobile app development)
- [Git](https://git-scm.com/)

---

## Local Setup

### 1. Clone the Repository

```bash
git clone https://github.com/sangmeshwar2006/CITY-CIVIC-.git
cd CITY-CIVIC-
```

### 2. Using Docker Compose (Quickest)

```bash
docker-compose up --build
```
This boots MongoDB, the backend API on port `5000`, and the admin panel on port `5173`.

### 3. Manual Setup

#### Backend
```bash
cd backend
cp .env.example .env
npm install
npm run seed
npm run dev
```

#### Admin Panel
```bash
cd admin
cp .env.example .env
npm install
npm run dev
```

#### Flutter App
```bash
cd flutter_app
flutter pub get
flutter run
```

---

## Development Workflow

1. **Create a Branch**: Always branch off `main` with a descriptive name:
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/issue-description
   ```

2. **Commit Conventions**: Keep commit messages concise and descriptive:
   ```bash
   git commit -m "Add feature: real-time notification on complaint resolution"
   ```

3. **Code Quality**:
   - Ensure code is properly formatted.
   - Do not commit `.env` files or credentials.
   - Test changes locally before submitting.

4. **Submit a Pull Request**:
   - Push your branch to GitHub: `git push origin feature/your-feature-name`
   - Open a Pull Request against the `main` branch.
   - Describe the changes made and link any related issues.

---

## Reporting Issues

If you find a bug or have a suggestion, please open an issue on GitHub with:
- A clear title and detailed description.
- Steps to reproduce the bug.
- Expected vs actual behavior.
- Screenshots or logs if applicable.

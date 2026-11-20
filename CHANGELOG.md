# Changelog

All notable changes to the **City Civic** project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.2.0] - 2026-11-20

### Added
- **System Architecture Guide** (`ARCHITECTURE.md`): Detailed component design, complaint state machine, schema documentation, and API reference.
- **Security Policy** (`SECURITY.md`): Vulnerability reporting procedures, supported versions, and deployment security practices.
- **Project Changelog** (`CHANGELOG.md`): Structured release history and version tracking.
- **Developer Makefile** (`Makefile`): Common development and operational commands for backend, admin, and Docker management.

---

## [1.1.0] - 2026-11-19

### Added
- **Docker Compose** (`docker-compose.yml`): Multi-container orchestration for MongoDB 6.0, Node API, and Vite Admin.
- **CI Pipeline** (`.github/workflows/ci.yml`): Automated GitHub Actions workflow testing backend syntax and admin dashboard build.
- **Contribution Guidelines** (`CONTRIBUTING.md`): Onboarding documentation, code of conduct, and pull request workflow.
- **Standalone Dockerfiles**: Production containers for Backend (Node 18 Alpine) and Admin Dashboard (Multi-stage Nginx SPA).
- **Uploads Directory Gitkeep**: Persistent tracking for runtime photo uploads.

---

## [1.0.0] - 2026-11-18

### Added
- **Backend API (`backend/`)**:
  - Express.js server with MongoDB integration.
  - JWT authentication for Citizens and Admins.
  - Complaint submission with geolocation and photo upload support.
  - Category filtering and resolution status management.
  - Analytical aggregations for municipal metrics.
  - Database seeding utility (`seedData.js`).
- **Admin Dashboard (`admin/`)**:
  - React 18 + Vite responsive administration dashboard.
  - Complaint triage table with status dropdown and delete controls.
  - Civic issue statistics cards.
  - Mobile and Admin interactive preview pages.
- **Flutter Mobile Client (`flutter_app/`)**:
  - Cross-platform citizen application.
  - Issue filing with camera capture and location tag.
  - Timeline tracking for complaint resolution progress.
  - Citizen login and registration screens.
- **Root Documentation**: Initial `README.md`, `LICENSE` (MIT), and `.gitignore`.

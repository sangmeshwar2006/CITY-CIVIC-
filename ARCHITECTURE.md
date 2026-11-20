# City Civic — System Architecture

This document describes the architectural design, component interactions, data models, and security principles governing the **City Civic** issue reporting platform.

---

## 1. System Overview

City Civic is designed as a three-tier civic engagement ecosystem:

```
+---------------------+         +----------------------+
|  Flutter Mobile App |         | React Vite Dashboard |
|     (Citizens)      |         |   (Administrators)   |
+----------+----------+         +----------+-----------+
           |                               |
           | HTTP / JSON                   | HTTP / JSON
           +--------------+ +--------------+
                          | |
                   +------v-v------+
                   | Express.js    |
                   | REST API      |
                   | (Port 5000)   |
                   +-------+-------+
                           |
             +-------------+-------------+
             |                           |
     +-------v-------+           +-------v-------+
     | MongoDB Atlas |           | Cloudinary /  |
     |  (Documents)  |           | Local Storage |
     +---------------+           +---------------+
```

### Components

1. **Flutter Mobile Application (`flutter_app/`)**:
   - Cross-platform client for iOS and Android.
   - Provides citizen registration, login, complaint submission with camera/gallery photos, geolocation capture, and real-time status tracking.

2. **Admin Dashboard (`admin/`)**:
   - Single Page Application built with React 18, Vite, and React Router.
   - Enables civic authorities to review incoming complaints, update resolution status, filter by categories, and view analytics charts.

3. **Backend API (`backend/`)**:
   - Node.js & Express REST API.
   - Manages authentication, issue persistence, media uploads, role enforcement, and analytics aggregation.

4. **Data Persistence (`MongoDB`)**:
   - Stores user profiles, credentials, civic complaints, and audit logs.

---

## 2. Complaint Lifecycle

Each complaint transitions through a managed state machine:

```
[ Submitted ]
      |
      v
[ Under Review ] ----> [ Rejected ] (Invalid / Duplicate)
      |
      v
[ In Progress ]
      |
      v
[  Resolved  ]
```

### State Definitions

- **Submitted**: Complaint recorded with timestamp, location coordinates, and photo evidence.
- **Under Review**: Assigned department reviews validity and jurisdiction.
- **In Progress**: Work order dispatched to field personnel.
- **Resolved**: Civic issue rectified with proof of work.
- **Rejected**: Out of municipal jurisdiction, duplicate, or invalid entry.

---

## 3. Data Models

### User Schema (`User.js`)
- `name` (String, required): Full name of the citizen or administrator.
- `email` (String, unique, required): User email address.
- `password` (String, required): Salted bcrypt hash.
- `role` (Enum: `['citizen', 'admin']`, default: `citizen`): Access control tier.
- `phone` (String, optional): Contact number.
- `createdAt` / `updatedAt`: Automatic Mongoose timestamps.

### Complaint Schema (`Complaint.js`)
- `title` (String, required): Brief headline of the issue.
- `description` (String, required): Detailed issue narrative.
- `category` (Enum: `['Roads', 'Garbage', 'Water', 'Electricity', 'Sewage', 'Other']`).
- `location` (Object): Latitude, longitude, and optional textual address.
- `imageUrl` (String, optional): Cloudinary URL or local static upload path.
- `status` (Enum: `['Submitted', 'Under Review', 'In Progress', 'Resolved', 'Rejected']`).
- `user` (ObjectId -> User): Reference to complaint author.
- `createdAt` / `updatedAt`: Automatic timestamps.

---

## 4. API Endpoints

### Authentication (`/api/auth`)
| Method | Path | Auth Required | Description |
| :--- | :--- | :--- | :--- |
| `POST` | `/api/auth/register` | No | Register citizen account |
| `POST` | `/api/auth/login` | No | Authenticate & issue JWT token |
| `GET` | `/api/auth/me` | Yes (Bearer) | Get current user profile |

### Complaints (`/api/complaints`)
| Method | Path | Auth Required | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/complaints` | Optional | Retrieve list with status/category filters |
| `POST` | `/api/complaints` | Yes (Citizen) | Submit a new civic complaint (supports multipart) |
| `GET` | `/api/complaints/:id` | No | Retrieve individual complaint details |
| `PUT` | `/api/complaints/:id/status` | Yes (Admin) | Update resolution status |
| `DELETE` | `/api/complaints/:id` | Yes (Admin) | Remove complaint record |

### Analytics (`/api/analytics`)
| Method | Path | Auth Required | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/analytics/overview` | Yes (Admin) | Aggregated counts by category and status |

---

## 5. Security & Isolation

- **Authentication**: Stateless HMAC-SHA256 JWT tokens with configurable TTL.
- **Authorization**: Middleware-enforced Role-Based Access Control (`adminOnly`).
- **Input Sanitization**: Express JSON body parsers with strict upload constraints.
- **Container Isolation**: Dockerized services connected over an isolated bridge network (`city-civic-network`).

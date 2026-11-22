# City Civic — REST API Documentation

Base URL: `http://localhost:5000/api` (Development)

All request and response bodies use standard `application/json` format unless specified otherwise (e.g. multipart for image uploads).

---

## Authentication

Protected endpoints require a standard Bearer token in the `Authorization` header:

```http
Authorization: Bearer <your_jwt_token>
```

---

## 1. Authentication Endpoints

### 1.1 Register Citizen
- **Method**: `POST`
- **Endpoint**: `/api/auth/register`
- **Access**: Public

**Request Body**:
```json
{
  "name": "Jane Citizen",
  "email": "jane@example.com",
  "password": "Password123"
}
```

**Response (201 Created)**:
```json
{
  "_id": "673f1a2b3c4d5e6f7a8b9c0d",
  "name": "Jane Citizen",
  "email": "jane@example.com",
  "role": "citizen",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

### 1.2 User Login
- **Method**: `POST`
- **Endpoint**: `/api/auth/login`
- **Access**: Public

**Request Body**:
```json
{
  "email": "jane@example.com",
  "password": "Password123"
}
```

**Response (200 OK)**:
```json
{
  "_id": "673f1a2b3c4d5e6f7a8b9c0d",
  "name": "Jane Citizen",
  "email": "jane@example.com",
  "role": "citizen",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

### 1.3 Get Current User Profile
- **Method**: `GET`
- **Endpoint**: `/api/auth/me`
- **Access**: Private (Citizen or Admin)

**Response (200 OK)**:
```json
{
  "_id": "673f1a2b3c4d5e6f7a8b9c0d",
  "name": "Jane Citizen",
  "email": "jane@example.com",
  "role": "citizen"
}
```

---

## 2. Complaint Endpoints

### 2.1 List Complaints
- **Method**: `GET`
- **Endpoint**: `/api/complaints`
- **Access**: Public
- **Query Parameters**:
  - `status` (optional): Filter by `Submitted`, `Under Review`, `In Progress`, `Resolved`, `Rejected`
  - `category` (optional): Filter by `Roads`, `Garbage`, `Water`, `Electricity`, `Sewage`, `Other`

**Example Request**:
```bash
curl -X GET "http://localhost:5000/api/complaints?status=Submitted&category=Roads"
```

**Response (200 OK)**:
```json
[
  {
    "_id": "673f1a2b3c4d5e6f7a8b9c10",
    "title": "Large Pothole on Main Street",
    "description": "Hazardous road crater causing traffic delays.",
    "category": "Roads",
    "status": "Submitted",
    "location": {
      "latitude": 17.9104,
      "longitude": 77.5199,
      "address": "Main Street, Sector 4"
    },
    "imageUrl": "/uploads/1732000000-pothole.jpg",
    "user": {
      "_id": "673f1a2b3c4d5e6f7a8b9c0d",
      "name": "Jane Citizen",
      "email": "jane@example.com"
    },
    "createdAt": "2026-11-20T10:15:00.000Z"
  }
]
```

---

### 2.2 Submit a Complaint
- **Method**: `POST`
- **Endpoint**: `/api/complaints`
- **Access**: Private (Citizen)
- **Content-Type**: `multipart/form-data`

**Form Fields**:
- `title` (text, required)
- `description` (text, required)
- `category` (text, required)
- `latitude` (numeric string, required)
- `longitude` (numeric string, required)
- `address` (text, optional)
- `image` (binary file, optional)

**Response (201 Created)**:
```json
{
  "_id": "673f1a2b3c4d5e6f7a8b9c11",
  "title": "Broken Streetlight",
  "description": "Streetlight pole non-functional for 3 days.",
  "category": "Electricity",
  "status": "Submitted",
  "location": {
    "latitude": 17.9125,
    "longitude": 77.5210,
    "address": "Ring Road Corner"
  },
  "imageUrl": "/uploads/1732001200-streetlight.jpg",
  "user": "673f1a2b3c4d5e6f7a8b9c0d",
  "createdAt": "2026-11-20T10:30:00.000Z"
}
```

---

### 2.3 Get Complaint by ID
- **Method**: `GET`
- **Endpoint**: `/api/complaints/:id`
- **Access**: Public

**Response (200 OK)**:
```json
{
  "_id": "673f1a2b3c4d5e6f7a8b9c11",
  "title": "Broken Streetlight",
  "status": "Submitted",
  "category": "Electricity",
  "description": "Streetlight pole non-functional for 3 days."
}
```

---

### 2.4 Update Complaint Status
- **Method**: `PUT`
- **Endpoint**: `/api/complaints/:id/status`
- **Access**: Private (Admin Only)

**Request Body**:
```json
{
  "status": "In Progress"
}
```

**Response (200 OK)**:
```json
{
  "_id": "673f1a2b3c4d5e6f7a8b9c11",
  "status": "In Progress",
  "message": "Complaint status updated successfully"
}
```

---

### 2.5 Delete Complaint
- **Method**: `DELETE`
- **Endpoint**: `/api/complaints/:id`
- **Access**: Private (Admin Only)

**Response (200 OK)**:
```json
{
  "message": "Complaint removed successfully"
}
```

---

## 3. Analytics Endpoints

### 3.1 Get Overview Metrics
- **Method**: `GET`
- **Endpoint**: `/api/analytics/overview`
- **Access**: Private (Admin Only)

**Response (200 OK)**:
```json
{
  "totalComplaints": 42,
  "byStatus": {
    "Submitted": 12,
    "Under Review": 8,
    "In Progress": 14,
    "Resolved": 6,
    "Rejected": 2
  },
  "byCategory": {
    "Roads": 15,
    "Garbage": 10,
    "Water": 7,
    "Electricity": 6,
    "Sewage": 4
  }
}
```

---

## 4. Error Responses

Standard JSON error structure:

```json
{
  "message": "Invalid credentials or token expired",
  "stack": null
}
```

| HTTP Code | Reason |
| :--- | :--- |
| `400 Bad Request` | Missing required fields or validation failure |
| `401 Unauthorized` | Missing or invalid Bearer token |
| `403 Forbidden` | Access denied (admin role required) |
| `404 Not Found` | Resource does not exist |
| `500 Server Error` | Unexpected backend or database exception |

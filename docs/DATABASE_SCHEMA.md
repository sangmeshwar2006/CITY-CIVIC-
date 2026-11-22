# City Civic — Database Schema

City Civic utilizes **MongoDB** (v6.0+) for its flexible document-oriented storage. This document outlines collection definitions, data types, indexing strategies, and relationships.

---

## Collections Overview

```
+---------------------+             +----------------------+
|        users        |             |      complaints      |
+---------------------+             +----------------------+
| _id: ObjectId       | 1         * | _id: ObjectId        |
| name: String        |<------------| user: ObjectId (FK)  |
| email: String (UQ)  |             | title: String        |
| password: String    |             | description: String  |
| role: String (Enum) |             | category: String     |
| createdAt: Date     |             | status: String       |
| updatedAt: Date     |             | location: Object     |
+---------------------+             | imageUrl: String     |
                                    | createdAt: Date      |
                                    | updatedAt: Date      |
                                    +----------------------+
```

---

## 1. `users` Collection

Represents registered citizens and administrative municipal staff.

### Schema Definition

| Field | Type | Required | Default | Description |
| :--- | :--- | :--- | :--- | :--- |
| `_id` | `ObjectId` | Yes | Auto | Unique user document ID |
| `name` | `String` | Yes | - | Full name of the user |
| `email` | `String` | Yes | - | Unique email address (lowercased) |
| `password` | `String` | Yes | - | Salted bcrypt password hash |
| `role` | `String` | Yes | `'citizen'` | Role: `'citizen'` or `'admin'` |
| `phone` | `String` | No | `null` | Optional contact telephone number |
| `createdAt` | `Date` | Yes | Auto | Account registration timestamp |
| `updatedAt` | `Date` | Yes | Auto | Last profile update timestamp |

### Indexes
```javascript
db.users.createIndex({ email: 1 }, { unique: true });
```

### Sample Document
```json
{
  "_id": { "$oid": "673f1a2b3c4d5e6f7a8b9c0d" },
  "name": "Sangmeshwar Admin",
  "email": "admin@citycivic.com",
  "password": "$2a$10$abcdefghijklmnopqrstuvwxyz1234567890",
  "role": "admin",
  "createdAt": { "$date": "2026-11-18T10:00:00.000Z" },
  "updatedAt": { "$date": "2026-11-18T10:00:00.000Z" }
}
```

---

## 2. `complaints` Collection

Represents civic issues reported by citizens.

### Schema Definition

| Field | Type | Required | Default | Description |
| :--- | :--- | :--- | :--- | :--- |
| `_id` | `ObjectId` | Yes | Auto | Unique complaint document ID |
| `title` | `String` | Yes | - | Brief title / summary of the civic problem |
| `description` | `String` | Yes | - | Detailed problem narrative |
| `category` | `String` | Yes | `'Other'` | Category enum (see below) |
| `status` | `String` | Yes | `'Submitted'` | Status enum (see below) |
| `location` | `Object` | Yes | - | Embedded coordinate object |
| `location.latitude` | `Number` | Yes | - | WGS84 latitude coordinate |
| `location.longitude` | `Number` | Yes | - | WGS84 longitude coordinate |
| `location.address` | `String` | No | `""` | Optional human-readable street address |
| `imageUrl` | `String` | No | `""` | Storage URL for photo evidence |
| `user` | `ObjectId` | Yes | - | References `users._id` (Complaint author) |
| `createdAt` | `Date` | Yes | Auto | Submission timestamp |
| `updatedAt` | `Date` | Yes | Auto | Last status modification timestamp |

### Enumerations

- **`category`**:
  `['Roads', 'Garbage', 'Water', 'Electricity', 'Sewage', 'Other']`
- **`status`**:
  `['Submitted', 'Under Review', 'In Progress', 'Resolved', 'Rejected']`

### Recommended Indexes
```javascript
// Querying complaints sorted by newest first
db.complaints.createIndex({ createdAt: -1 });

// Filtering complaints by status and category in admin portal
db.complaints.createIndex({ status: 1, category: 1 });

// Finding all complaints filed by a specific user
db.complaints.createIndex({ user: 1 });
```

### Sample Document
```json
{
  "_id": { "$oid": "673f1a2b3c4d5e6f7a8b9c10" },
  "title": "Severe Water Pipe Leak",
  "description": "Clean water overflowing onto 4th Cross Road due to burst pipeline.",
  "category": "Water",
  "status": "In Progress",
  "location": {
    "latitude": 17.9150,
    "longitude": 77.5240,
    "address": "4th Cross Road, Bidar"
  },
  "imageUrl": "/uploads/1732001500-pipe-leak.jpg",
  "user": { "$oid": "673f1a2b3c4d5e6f7a8b9c0d" },
  "createdAt": { "$date": "2026-11-20T11:00:00.000Z" },
  "updatedAt": { "$date": "2026-11-20T14:30:00.000Z" }
}
```

---

## 3. Database Maintenance

### Database Backup
```bash
mongodump --uri="mongodb://127.0.0.1:27017/city-civic" --out=/backup/$(date +%F)
```

### Database Restore
```bash
mongorestore --uri="mongodb://127.0.0.1:27017/city-civic" /backup/2026-11-22/city-civic
```

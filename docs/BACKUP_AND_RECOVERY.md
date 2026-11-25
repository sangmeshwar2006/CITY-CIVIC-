# City Civic — Backup & Disaster Recovery Protocol

This protocol defines the strategies, schedules, and procedures to ensure business continuity and zero data loss for the **City Civic** municipal reporting system.

---

## 1. Recovery Objectives

- **Recovery Point Objective (RPO)**: **< 1 Hour**  
  Maximum acceptable data loss in the event of an unplanned incident.
- **Recovery Time Objective (RTO)**: **< 30 Minutes**  
  Maximum acceptable duration to restore the database and services to operational status.

---

## 2. Backup Strategy

```
+---------------------------------------------------------------------------------+
|                                 Backup Tiers                                    |
|                                                                                 |
|  [ Hourly Incremental ]   -->   Local Compressed Snapshot  -->  AWS S3 Bucket   |
|  [ Daily Full Dump   ]   -->   Retention: 30 Days         -->  Glacier Archive |
+---------------------------------------------------------------------------------+
```

### 2.1 Automated Local Snapshots
Local database dumps are generated via `scripts/backup.sh` and retained on the server for 7 days.

### 2.2 Off-Site Replication
- Snapshots are automatically synchronized to an encrypted S3 bucket (or Azure Blob Storage) with server-side AES-256 encryption.
- Lifecycle rules transition daily archives to Glacier after 30 days and permanently purge after 365 days.

---

## 3. Automated Backup Procedure

To trigger a manual database backup:

```bash
chmod +x scripts/backup.sh
./scripts/backup.sh /var/backups/city-civic
```

The script will:
1. Export binary BSON collections using `mongodump`.
2. Package the output into a timestamped `.tar.gz` archive.
3. Remove backups older than 7 days to conserve disk space.

---

## 4. Disaster Recovery & Restoration

### Step 1: Provision Clean Target Environment
Ensure MongoDB is running on the target server:
```bash
docker-compose up -d mongodb
```

### Step 2: Extract Backup Archive
```bash
mkdir -p /tmp/restore
tar -xzvf /var/backups/city-civic/city-civic-backup-20261125_120000.tar.gz -C /tmp/restore
```

### Step 3: Execute Database Restore
```bash
mongorestore \
  --uri="mongodb://127.0.0.1:27017/city-civic" \
  --drop \
  /tmp/restore/city-civic
```
> [!WARNING]
> The `--drop` flag will replace existing collections with the snapshot data. Use caution in production environments.

### Step 4: Verify System Integrity
Execute the automated health check script to confirm database indexing and API readiness:
```bash
./scripts/healthcheck.sh
```

---

## 5. Annual Disaster Recovery Drill

Municipal administrators conduct bi-annual simulated recovery drills:
1. Simulating full database wipe on staging.
2. Timing the restoration procedure against RTO (<30 mins).
3. Verifying that all citizen tickets, admin credentials, and image links match pre-drill hashes.

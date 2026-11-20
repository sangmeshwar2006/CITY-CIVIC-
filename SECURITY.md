# Security Policy

The City Civic project team takes the security of our civic issue platform and our users' data seriously. This policy outlines our vulnerability reporting process and security safeguards.

---

## Supported Versions

Only the latest release on the `main` branch receives active security updates.

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |
| < 1.0.0 | :x:                |

---

## Reporting a Vulnerability

If you discover a security vulnerability within City Civic:

1. **Do not disclose publicly**: Please refrain from opening a public GitHub issue detailing an active vulnerability.
2. **Private Disclosure**: Send an advisory via GitHub Private Vulnerability Reporting or email the maintainer at `yerbagesangmeshwar2006@gmail.com`.
3. **Include Details**:
   - Component affected (`backend`, `admin`, `flutter_app`, or Docker infrastructure)
   - Steps to reproduce or proof-of-concept
   - Impact assessment
   - Potential remediation if known

### Response Timeline

- **Initial Response**: Within 48 hours acknowledging receipt.
- **Triage & Assessment**: Within 5 business days.
- **Fix & Disclosure**: Coordinated release with patched version and public security advisory.

---

## Security Best Practices

### Credentials & Secrets
- Never commit `.env` or production secrets to Git.
- Always generate cryptographically secure random values for `JWT_SECRET`.
- For production MongoDB deployments, enforce TLS connections and IP access whitelisting.

### Media & Uploads
- File uploads are validated via Multer for permitted MIME types (e.g., JPEG, PNG).
- When using Cloudinary, ensure API secrets are stored as environment variables.
- When using local uploads, path traversal checks are enforced.

### Role-Based Access Control (RBAC)
- All privileged endpoints (`/api/analytics`, `/api/complaints/:id/status`) require signed JWT verification and `admin` role validation via `authMiddleware.js`.

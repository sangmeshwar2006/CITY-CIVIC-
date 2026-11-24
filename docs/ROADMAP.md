# City Civic — Product & Engineering Roadmap

This roadmap documents the strategic vision, upcoming milestones, and architectural evolution of the **City Civic** platform.

---

## Vision Statement

> To empower citizens and municipal departments with a transparent, responsive, and accountable digital ecosystem for civic issue resolution.

---

## Milestone Timeline

```
+---------------------------------------------------------------------------------+
| Q4 2026: Foundation     | Q1 2027: Engagement    | Q2 2027: Intelligence        |
| - Monorepo Structure    | - Real-time Alerts     | - Automated AI Triage        |
| - Express / React / App | - Interactive Maps     | - Duplicate Issue Detection  |
| - Docker & CI/CD        | - Citizen Feedback     | - Municipal SLA Escalation   |
+---------------------------------------------------------------------------------+
```

---

## Phase 1: Platform Foundation (Completed / Current)

- [x] Full-stack architecture with Express REST API, React Vite Admin, and Flutter mobile client.
- [x] Role-Based Access Control (`citizen` vs `admin`) with signed JWT tokens.
- [x] Complaint lifecycle state machine (`Submitted` -> `Under Review` -> `In Progress` -> `Resolved` / `Rejected`).
- [x] Docker Compose multi-container setup with MongoDB.
- [x] Automated testing suite (`node:test`, `flutter_test`) and GitHub Actions CI pipeline.
- [x] Open-source governance: Code of Conduct, PR & Issue templates, Architecture & Security policies.

---

## Phase 2: Real-time Engagement & Geospatial (Q1 2027)

- [ ] **Interactive Map View**:
  - Integration of Mapbox / Leaflet in the React admin dashboard to visualize complaints geographically.
  - Heatmap layers showing high-density problem zones (e.g., recurring potholes, garbage accumulation).
- [ ] **Push Notifications & SMS Alerts**:
  - Firebase Cloud Messaging (FCM) integration for real-time status updates pushed to citizens' mobile devices.
  - SMS notification triggers via Twilio / Fast2SMS for users without active data connections.
- [ ] **Citizen Satisfaction Ratings**:
  - Post-resolution citizen rating (1 to 5 stars) and feedback comments upon ticket closure.

---

## Phase 3: AI Triage & Municipal Automation (Q2 2027)

- [ ] **Duplicate Issue Detection**:
  - Computer Vision & Embedding comparison to identify if a nearby complaint has already been submitted for the same issue.
  - Automatic clustering of related complaints into a single work order.
- [ ] **Department Auto-Routing**:
  - Natural Language Processing (NLP) classification of complaint titles/descriptions to automatically route tickets to the correct department (Public Works, Sanitation, Water Board, BESCOM).
- [ ] **SLA & Escalation Engine**:
  - Automated alerts when a complaint remains unattended past defined SLA thresholds (e.g., 48 hours for Sewage, 7 days for Potholes).

---

## Phase 4: Public Transparency & Open Civic Data (Q3 2027)

- [ ] **Public Transparency Portal**:
  - Read-only public dashboard displaying resolved issue metrics, average resolution time, and ward performance.
- [ ] **Open Civic API**:
  - Rate-limited public API endpoints for civic research, municipal audit teams, and community journalists.
- [ ] **Multilingual Support**:
  - Localization for regional languages (Kannada, Hindi, Marathi) across both Flutter mobile app and Admin portal.

---

## Contributing to the Roadmap

We welcome feedback and community contributions! If you would like to champion a feature from this roadmap, please open a discussion or reference the relevant milestone in a [Feature Request](https://github.com/sangmeshwar2006/CITY-CIVIC-/issues/new?template=feature_request.md).

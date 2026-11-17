import { useMemo, useState } from "react";
import { Link } from "react-router-dom";
import ComplaintTable from "../components/ComplaintTable";
import StatCard from "../components/StatCard";

const mockComplaints = [
  {
    _id: "1",
    title: "Overflowing garbage bin near market",
    category: "Garbage",
    location: { lat: 12.9716, lng: 77.5946 },
    status: "Pending",
    createdAt: "2026-04-25T08:30:00.000Z",
  },
  {
    _id: "2",
    title: "Pothole causing traffic slowdown",
    category: "Road",
    location: { lat: 12.9732, lng: 77.6010 },
    status: "In Progress",
    createdAt: "2026-04-26T10:15:00.000Z",
  },
  {
    _id: "3",
    title: "Streetlight outage near park gate",
    category: "Electricity",
    location: { lat: 12.9694, lng: 77.5901 },
    status: "Resolved",
    createdAt: "2026-04-27T19:45:00.000Z",
  },
];

export default function AdminPreviewPage() {
  const [complaints, setComplaints] = useState(mockComplaints);
  const [filters, setFilters] = useState({ category: "", status: "" });
  const visibleComplaints = useMemo(
    () => complaints.filter((item) =>
      (!filters.category || item.category === filters.category) &&
      (!filters.status || item.status === filters.status)
    ),
    [complaints, filters]
  );

  const updateStatus = (id, status) => setComplaints((items) =>
    items.map((item) => item._id === id ? { ...item, status } : item)
  );

  return (
    <main className="dashboard-layout">
      <header className="dashboard-header">
        <div>
          <p className="eyebrow">Interactive browser preview</p>
          <h1>Admin Dashboard Preview</h1>
        </div>
        <div className="header-actions">
          <Link className="secondary-button" to="/preview">
            Mobile Preview
          </Link>
          <Link className="secondary-button" to="/login">
            Real Login
          </Link>
        </div>
      </header>

      <section className="stats-grid">
        <StatCard label="Total complaints" value={complaints.length} />
        <StatCard
          label="Resolved"
          value={complaints.filter((item) => item.status === "Resolved").length}
        />
        <StatCard label="Top category" value={topCategory(complaints)} />
      </section>

      <section className="panel">
        <div className="panel-row">
          <h2>Complaints</h2>
          <div className="filters">
            <select value={filters.category} onChange={(event) => setFilters((value) => ({ ...value, category: event.target.value }))}>
              <option value="">All categories</option>
              <option value="Garbage">Garbage</option>
              <option value="Road">Road</option>
              <option value="Water">Water</option>
              <option value="Electricity">Electricity</option>
              <option value="Other">Other</option>
            </select>
            <select value={filters.status} onChange={(event) => setFilters((value) => ({ ...value, status: event.target.value }))}>
              <option value="">All statuses</option>
              <option value="Pending">Pending</option>
              <option value="In Progress">In Progress</option>
              <option value="Resolved">Resolved</option>
            </select>
          </div>
        </div>
        <ComplaintTable
          complaints={visibleComplaints}
          onStatusChange={updateStatus}
          onDelete={(id) => setComplaints((items) => items.filter((item) => item._id !== id))}
        />
      </section>
    </main>
  );
}

function topCategory(items) {
  const counts = items.reduce((result, item) => {
    result[item.category] = (result[item.category] || 0) + 1;
    return result;
  }, {});
  return Object.entries(counts).sort((a, b) => b[1] - a[1])[0]?.[0] || "None";
}

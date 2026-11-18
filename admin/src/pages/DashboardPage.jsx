import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import ComplaintTable from "../components/ComplaintTable";
import StatCard from "../components/StatCard";
import { useAuth } from "../context/AuthContext";
import {
  deleteComplaint,
  fetchAnalytics,
  fetchComplaints,
  updateComplaintStatus,
} from "../services/complaintService";

const categories = ["", "Garbage", "Road", "Water", "Electricity", "Other"];
const statuses = ["", "Pending", "In Progress", "Resolved"];

export default function DashboardPage() {
  const { user, logout } = useAuth();
  const [complaints, setComplaints] = useState([]);
  const [analytics, setAnalytics] = useState({ byCategory: [], byStatus: [] });
  const [filters, setFilters] = useState({ category: "", status: "" });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const loadData = async () => {
    setLoading(true);
    setError("");
    try {
      const [complaintData, analyticsData] = await Promise.all([
        fetchComplaints(filters),
        fetchAnalytics(),
      ]);
      setComplaints(complaintData);
      setAnalytics(analyticsData);
    } catch (loadError) {
      setError(loadError.response?.data?.message || "Failed to load dashboard");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadData();
  }, [filters.category, filters.status]);

  const handleStatusChange = async (id, status) => {
    try {
      await updateComplaintStatus(id, status);
      await loadData();
    } catch (updateError) {
      setError(updateError.response?.data?.message || "Failed to update status");
    }
  };

  const handleDelete = async (id) => {
    try {
      await deleteComplaint(id);
      await loadData();
    } catch (deleteError) {
      setError(deleteError.response?.data?.message || "Failed to delete complaint");
    }
  };

  return (
    <main className="dashboard-layout">
      <header className="dashboard-header">
        <div>
          <p className="eyebrow">Welcome back</p>
          <h1>{user?.name || "Admin"}</h1>
        </div>
        <div className="header-actions">
          <Link className="secondary-button" to="/preview">
            Mobile Preview
          </Link>
          <button onClick={logout}>Logout</button>
        </div>
      </header>

      <section className="stats-grid">
        <StatCard label="Total complaints" value={complaints.length} />
        <StatCard
          label="Resolved"
          value={complaints.filter((item) => item.status === "Resolved").length}
        />
        <StatCard
          label="Top category"
          value={analytics.byCategory[0]?._id || "None"}
        />
      </section>

      <section className="panel">
        <div className="panel-row">
          <h2>Complaints</h2>
          <div className="filters">
            <select
              value={filters.category}
              onChange={(event) =>
                setFilters({ ...filters, category: event.target.value })
              }
            >
              {categories.map((option) => (
                <option key={option || "all"} value={option}>
                  {option || "All categories"}
                </option>
              ))}
            </select>
            <select
              value={filters.status}
              onChange={(event) =>
                setFilters({ ...filters, status: event.target.value })
              }
            >
              {statuses.map((option) => (
                <option key={option || "all"} value={option}>
                  {option || "All statuses"}
                </option>
              ))}
            </select>
          </div>
        </div>
        {error ? <div className="error-box">{error}</div> : null}
        {loading ? (
          <p className="muted">Loading complaints...</p>
        ) : (
          <ComplaintTable
            complaints={complaints}
            onStatusChange={handleStatusChange}
            onDelete={handleDelete}
          />
        )}
      </section>
    </main>
  );
}

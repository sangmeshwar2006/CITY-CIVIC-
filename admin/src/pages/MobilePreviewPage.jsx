import { useState } from "react";
import { Link } from "react-router-dom";

const initialComplaints = [
  { id: "1", title: "Streetlight out near park gate", category: "Electricity", status: "In Progress", description: "The stretch near the park entrance is dark after 8 PM and residents feel unsafe.", address: "Park Gate Ward 3" },
  { id: "2", title: "Garbage piling up by market lane", category: "Garbage", status: "Pending", description: "Waste has not been collected for two days.", address: "Market Lane" },
];
const categories = ["Garbage", "Road", "Water", "Electricity", "Other"];

export default function MobilePreviewPage() {
  const [screen, setScreen] = useState("login");
  const [complaints, setComplaints] = useState(initialComplaints);
  const [selected, setSelected] = useState(initialComplaints[0]);
  const [statusFilter, setStatusFilter] = useState("");
  const [notice, setNotice] = useState("");
  const [imageName, setImageName] = useState("");

  const submitComplaint = (event) => {
    event.preventDefault();
    const data = new FormData(event.currentTarget);
    const item = {
      id: String(Date.now()),
      title: data.get("title").trim(),
      description: data.get("description").trim(),
      category: data.get("category"),
      status: "Pending",
      address: "Bengaluru Civic Zone",
    };
    setComplaints((items) => [item, ...items]);
    setSelected(item);
    setNotice("Your report was added to this preview.");
    setScreen("home");
  };

  const openDetails = (item) => { setSelected(item); setNotice(""); setScreen("details"); };

  return (
    <main className="preview-layout">
      <header className="dashboard-header preview-header">
        <div><p className="eyebrow">Interactive app preview</p><h1>City Civic on mobile</h1></div>
        <Link className="secondary-button" to="/admin-preview">Back to admin preview</Link>
      </header>
      <section className="preview-hero">
        <div><p className="eyebrow">Try the flow</p><h2>Tap through the citizen app</h2>
          <p className="muted">Sign in, filter and open reports, or submit a new one. Changes stay in this browser preview.</p></div>
      </section>
      <div className="device-preview-wrap">
        <nav className="screen-picker" aria-label="Preview screens">
          {[ ["login", "Login"], ["signup", "Create account"], ["home", "My reports"], ["add", "New report"] ].map(([key, label]) =>
            <button key={key} className={screen === key ? "screen-tab active" : "screen-tab"} onClick={() => { setNotice(""); setScreen(key); }}>{label}</button>
          )}
        </nav>
        <article className="phone-shell live-phone">
          <div className="phone-topbar"><span>9:41</span><span>City Civic App</span><span>●●●</span></div>
          <div className="phone-screen live-phone-screen">
            {screen === "login" && <form className="mobile-form auth-mock" onSubmit={(event) => { event.preventDefault(); setScreen("home"); setNotice("Welcome to your preview account."); }}>
              <div className="auth-badge">City Civic</div><h3>Report city issues in a few taps</h3><p className="muted">Track neighborhood issues and keep up with their progress.</p>
              <label>Email<input type="email" name="email" placeholder="you@example.com" required /></label>
              <label>Password<input type="password" name="password" placeholder="At least 6 characters" minLength="6" required /></label>
              <button className="mock-primary" type="submit">Login</button>
              <button className="mock-link" type="button" onClick={() => setScreen("signup")}>Create a new account</button>
            </form>}
            {screen === "signup" && <form className="mobile-form" onSubmit={(event) => { event.preventDefault(); setScreen("home"); setNotice("Your preview account is ready."); }}>
              <button type="button" className="back-link" onClick={() => setScreen("login")}>← Back to login</button><h3>Create account</h3>
              <label>Full name<input name="name" placeholder="Your name" required /></label><label>Email<input name="email" type="email" placeholder="you@example.com" required /></label>
              <label>Password<input name="password" type="password" minLength="6" placeholder="At least 6 characters" required /></label><button className="mock-primary">Sign up</button>
            </form>}
            {screen === "home" && <div className="mobile-content"><div className="mobile-appbar"><div><p className="eyebrow">Hello Rahul</p><h3>My reports</h3></div><button className="small-button" onClick={() => { setScreen("login"); setNotice(""); }}>Log out</button></div>
              {notice && <p className="success-box">{notice}</p>}
              <label className="filter-label">Filter by status<select value={statusFilter} onChange={(event) => setStatusFilter(event.target.value)}><option value="">All statuses</option><option>Pending</option><option>In Progress</option><option>Resolved</option></select></label>
              <div className="mobile-card-list">{complaints.filter((item) => !statusFilter || item.status === statusFilter).map((item) => <button className="mobile-card" key={item.id} onClick={() => openDetails(item)}>
                <span className="card-illustration" aria-hidden="true">{item.category === "Garbage" ? "♻️" : item.category === "Electricity" ? "💡" : item.category === "Road" ? "🛣️" : item.category === "Water" ? "💧" : "📍"}</span>
                <span className="mobile-card-copy"><strong>{item.title}</strong><span>{item.category}</span><span className={`status-pill status-${slug(item.status)}`}>{item.status}</span></span>
              </button>)}</div>
              {complaints.filter((item) => !statusFilter || item.status === statusFilter).length === 0 && <p className="empty-mobile">No reports with this status.</p>}
              <button className="mock-primary" onClick={() => { setNotice(""); setScreen("add"); }}>＋ Report an issue</button>
            </div>}
            {screen === "add" && <form className="mobile-form" onSubmit={submitComplaint}>
              <button type="button" className="back-link" onClick={() => setScreen("home")}>← My reports</button><h3>Report an issue</h3>
              <label>Title<input name="title" placeholder="What needs attention?" maxLength="100" required /></label>
              <label>Description<textarea name="description" placeholder="Add details and nearby landmarks" rows="4" maxLength="1000" required /></label>
              <label>Category<select name="category" defaultValue="Road">{categories.map((category) => <option key={category}>{category}</option>)}</select></label>
              <label className="upload-control">Photo (optional)<input type="file" accept="image/*" onChange={(event) => setImageName(event.target.files?.[0]?.name || "")} /></label>
              {imageName && <p className="muted file-name">Selected: {imageName}</p>}
              <div className="mock-location"><strong>Approximate location</strong><span>Bengaluru Civic Zone · 12.9716, 77.5946</span></div>
              <button className="mock-primary">Submit report</button>
            </form>}
            {screen === "details" && selected && <div className="mobile-content">
              <button type="button" className="back-link" onClick={() => setScreen("home")}>← My reports</button>
              <div className="detail-art" aria-hidden="true">{selected.category === "Electricity" ? "💡" : selected.category === "Garbage" ? "♻️" : "📍"}</div>
              <h3>{selected.title}</h3><div className="detail-meta"><span className={`status-pill status-${slug(selected.status)}`}>{selected.status}</span><span className="tag-pill">{selected.category}</span></div>
              <p className="detail-copy">{selected.description}</p><div className="mock-location detail-location"><strong>Location</strong><span>{selected.address}</span></div>
              <h4>Status updates</h4><div className="timeline-block">{["Pending", "In Progress", "Resolved"].map((status, index) => <div className="timeline-row" key={status}><div className="timeline-dot-wrap"><span className={`timeline-dot ${status === selected.status ? "current" : ""}`} />{index < 2 && <span className="timeline-line" />}</div><div><strong>{status}</strong><p>{status === "Pending" ? "Report received" : status === "In Progress" ? "Assigned to the ward team" : "Issue fixed and verified"}</p></div></div>)}</div>
            </div>}
          </div>
        </article>
      </div>
    </main>
  );
}

function slug(value) { return value.toLowerCase().replace(/\s+/g, "-"); }

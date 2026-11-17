const statusOptions = ["Pending", "In Progress", "Resolved"];

export default function ComplaintTable({
  complaints,
  onStatusChange,
  onDelete,
}) {
  return (
    <div className="table-shell">
      <table>
        <thead>
          <tr>
            <th>Title</th>
            <th>Category</th>
            <th>Location</th>
            <th>Status</th>
            <th>Date</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {complaints.length === 0 ? (
            <tr><td colSpan="6">No complaints match these filters.</td></tr>
          ) : complaints.map((complaint) => (
            <tr key={complaint._id}>
              <td>{complaint.title}</td>
              <td>{complaint.category}</td>
              <td>
                {complaint.location?.lat}, {complaint.location?.lng}
              </td>
              <td>
                <select
                  value={complaint.status}
                  onChange={(event) =>
                    onStatusChange(complaint._id, event.target.value)
                  }
                >
                  {statusOptions.map((status) => (
                    <option key={status} value={status}>
                      {status}
                    </option>
                  ))}
                </select>
              </td>
              <td>{new Date(complaint.createdAt).toLocaleDateString()}</td>
              <td>
                <button
                  className="danger-button"
                  onClick={() => onDelete(complaint._id)}
                >
                  Delete
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

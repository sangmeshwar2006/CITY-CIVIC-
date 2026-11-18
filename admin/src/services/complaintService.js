import api from "./api";

export const fetchComplaints = async (filters = {}) => {
  const { data } = await api.get("/complaints", { params: filters });
  return data;
};

export const updateComplaintStatus = async (id, status) => {
  const { data } = await api.put(`/complaints/${id}`, { status });
  return data;
};

export const deleteComplaint = async (id) => {
  const { data } = await api.delete(`/complaints/${id}`);
  return data;
};

export const fetchAnalytics = async () => {
  const { data } = await api.get("/analytics");
  return data;
};

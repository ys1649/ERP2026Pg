import axios from 'axios'

const api = axios.create({ baseURL: '/api' })

export const employeeApi = {
  list: (params) => api.get('/employees', { params }),
  get: (id) => api.get(`/employees/${id}`),
  create: (data) => api.post('/employees', data),
  update: (id, data) => api.put(`/employees/${id}`, data),
  remove: (id) => api.delete(`/employees/${id}`),
  renumber: (id, newNo) => api.put(`/employees/${id}/renumber`, { new_no: newNo }),
}

import axios from 'axios'

const api = axios.create({ baseURL: '/api' })

export const supplierApi = {
  list: (params) => api.get('/suppliers', { params }),
  get: (id) => api.get(`/suppliers/${id}`),
  create: (data) => api.post('/suppliers', data),
  update: (id, data) => api.put(`/suppliers/${id}`, data),
  remove: (id) => api.delete(`/suppliers/${id}`),
  renumber: (id, newNo) => api.put(`/suppliers/${id}/renumber`, { new_no: newNo }),
}

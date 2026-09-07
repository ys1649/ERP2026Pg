import axios from 'axios'

const api = axios.create({ baseURL: '/api' })

export const carApi = {
  list: (params) => api.get('/cars', { params }),
  get: (id) => api.get(`/cars/${id}`),
  create: (data) => api.post('/cars', data),
  update: (id, data) => api.put(`/cars/${id}`, data),
  remove: (id) => api.delete(`/cars/${id}`),
  renumber: (id, newNo) => api.put(`/cars/${id}/renumber`, { new_no: newNo }),
}

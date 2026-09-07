import axios from 'axios'

const api = axios.create({ baseURL: '/api' })

export const productApi = {
  list: (params) => api.get('/products', { params }),
  get: (id) => api.get(`/products/${id}`),
  create: (data) => api.post('/products', data),
  update: (id, data) => api.put(`/products/${id}`, data),
  remove: (id) => api.delete(`/products/${id}`),
  renumber: (id, newNo) => api.put(`/products/${id}/renumber`, { new_no: newNo }),
}

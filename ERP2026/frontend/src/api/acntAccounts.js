import axios from 'axios'

const api = axios.create({ baseURL: '/api' })

export const acntAccountApi = {
  list: (params) => api.get('/acnt-accounts', { params }),
  get: (id) => api.get(`/acnt-accounts/${id}`),
  create: (data) => api.post('/acnt-accounts', data),
  update: (id, data) => api.put(`/acnt-accounts/${id}`, data),
  remove: (id) => api.delete(`/acnt-accounts/${id}`),
  listTypes: () => api.get('/acnt-accounts/types'),
}

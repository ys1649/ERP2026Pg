import axios from 'axios'

const api = axios.create({ baseURL: '/api' })

export const shipApi = {
  list: (params) => api.get('/ship', { params }),
  get: (smtNo) => api.get(`/ship/${smtNo}`),
  create: (data) => api.post('/ship', data),
  update: (smtNo, data) => api.put(`/ship/${smtNo}`, data),
  remove: (smtNo) => api.delete(`/ship/${smtNo}`),
  book: (smtNo) => api.post(`/ship/${smtNo}/book`),
  unbook: (smtNo) => api.post(`/ship/${smtNo}/unbook`),
  quickCollect: (smtNo, data) => api.post(`/ship/${smtNo}/quick-collect`, data),
  price: (cumNo, prdNo) => api.get('/ship/price', { params: { cum_no: cumNo, prd_no: prdNo } }),
  history: (cumNo, exclude) => api.get(`/ship/history/${cumNo}`, { params: { exclude } }),
}

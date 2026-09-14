import axios from 'axios'

const api = axios.create({ baseURL: '/api' })

export const invAdjustApi = {
  list: (params) => api.get('/inv-adjust', { params }),
  get: (adjNo) => api.get(`/inv-adjust/${adjNo}`),
  create: (data) => api.post('/inv-adjust', data),
  update: (adjNo, data) => api.put(`/inv-adjust/${adjNo}`, data),
  remove: (adjNo) => api.delete(`/inv-adjust/${adjNo}`),
  book: (adjNo) => api.post(`/inv-adjust/${adjNo}/book`),
  unbook: (adjNo) => api.post(`/inv-adjust/${adjNo}/unbook`),
  currentCost: (prdNo) => api.get('/inv-adjust/price', { params: { prd_no: prdNo } }),
}

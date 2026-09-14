import axios from 'axios'

const api = axios.create({ baseURL: '/api' })

export const poRecvApi = {
  list: (params) => api.get('/po-recv', { params }),
  get: (rcvNo) => api.get(`/po-recv/${rcvNo}`),
  create: (data) => api.post('/po-recv', data),
  update: (rcvNo, data) => api.put(`/po-recv/${rcvNo}`, data),
  remove: (rcvNo) => api.delete(`/po-recv/${rcvNo}`),
  book: (rcvNo) => api.post(`/po-recv/${rcvNo}/book`),
  unbook: (rcvNo) => api.post(`/po-recv/${rcvNo}/unbook`),
  quickPay: (rcvNo, data) => api.post(`/po-recv/${rcvNo}/quick-pay`, data),
  price: (supNo, prdNo) => api.get('/po-recv/price', { params: { sup_no: supNo, prd_no: prdNo } }),
  history: (supNo, exclude) => api.get(`/po-recv/history/${supNo}`, { params: { exclude } }),
}

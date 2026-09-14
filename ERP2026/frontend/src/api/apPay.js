import axios from 'axios'

const api = axios.create({ baseURL: '/api' })

export const apPayApi = {
  list: (params) => api.get('/ap-pay', { params }),
  get: (payNo) => api.get(`/ap-pay/${payNo}`),
  create: (data) => api.post('/ap-pay', data),
  remove: (payNo) => api.delete(`/ap-pay/${payNo}`),
  candidates: (supNo, payDate) => api.get('/ap-pay/candidates', { params: { sup_no: supNo, pay_date: payDate } }),
}

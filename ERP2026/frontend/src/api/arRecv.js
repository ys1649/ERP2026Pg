import axios from 'axios'

const api = axios.create({ baseURL: '/api' })

export const arRecvApi = {
  list: (params) => api.get('/ar-recv', { params }),
  get: (arrNo) => api.get(`/ar-recv/${arrNo}`),
  create: (data) => api.post('/ar-recv', data),
  remove: (arrNo) => api.delete(`/ar-recv/${arrNo}`),
  candidates: (cumNo, arrDate) => api.get('/ar-recv/candidates', { params: { cum_no: cumNo, arr_date: arrDate } }),
}

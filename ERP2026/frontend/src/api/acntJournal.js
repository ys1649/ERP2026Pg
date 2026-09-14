import axios from 'axios'

const api = axios.create({ baseURL: '/api' })

export const acntJournalApi = {
  list: (params) => api.get('/acnt-journal', { params }),
  get: (jnlNo) => api.get(`/acnt-journal/${jnlNo}`),
  create: (data) => api.post('/acnt-journal', data),
  update: (jnlNo, data) => api.put(`/acnt-journal/${jnlNo}`, data),
  remove: (jnlNo) => api.delete(`/acnt-journal/${jnlNo}`),
}

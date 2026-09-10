import axios from 'axios'

const api = axios.create({ baseURL: '/api', timeout: 5 * 60 * 1000 })

export const backupApi = {
  export: () => api.get('/backup/export', { responseType: 'blob' }),
  restore: (file) => {
    const formData = new FormData()
    formData.append('file', file)
    return api.post('/backup/restore', formData, { headers: { 'Content-Type': 'multipart/form-data' } })
  },
}

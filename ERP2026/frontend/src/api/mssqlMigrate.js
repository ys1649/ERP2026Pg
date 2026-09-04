import axios from 'axios'

const api = axios.create({ baseURL: '/api', timeout: 5 * 60 * 1000 })

export const mssqlMigrateApi = {
  test: (conn) => api.post('/mssql-migrate/test', conn),
  run: (conn) => api.post('/mssql-migrate/run', conn),
}

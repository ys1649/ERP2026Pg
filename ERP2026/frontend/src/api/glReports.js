import axios from 'axios'

const api = axios.create({ baseURL: '/api' })

export const glReportsApi = {
  asset: (dtEnd) => api.get('/gl-reports/asset', { params: { dt_end: dtEnd } }),
  incomeDefaults: () => api.get('/gl-reports/income-defaults'),
  income: (dtFrom, dtTo) => api.get('/gl-reports/income', { params: { dt_from: dtFrom, dt_to: dtTo } }),
  balanceDefaults: () => api.get('/gl-reports/balance-defaults'),
  balance: (dtEnd) => api.get('/gl-reports/balance', { params: { dt_end: dtEnd } }),
  dailyDefaults: () => api.get('/gl-reports/daily-defaults'),
  daily: (dtFrom, dtTo) => api.get('/gl-reports/daily', { params: { dt_from: dtFrom, dt_to: dtTo } }),
  trialDefaults: () => api.get('/gl-reports/trial-defaults'),
  trial: (dtFrom, dtTo) => api.get('/gl-reports/trial', { params: { dt_from: dtFrom, dt_to: dtTo } }),
  cashDefaults: () => api.get('/gl-reports/cash-defaults'),
  cash: (dtFrom, dtTo) => api.get('/gl-reports/cash', { params: { dt_from: dtFrom, dt_to: dtTo } }),
  detailDefaults: () => api.get('/gl-reports/detail-defaults'),
  detail: (dtFrom, dtTo, actNoFrom, actNoTo) => api.get('/gl-reports/detail', {
    params: { dt_from: dtFrom, dt_to: dtTo, act_no_from: actNoFrom || undefined, act_no_to: actNoTo || undefined },
  }),
}

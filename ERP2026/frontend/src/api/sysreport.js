import axios from 'axios'

const api = axios.create({ baseURL: '/api' })

export const sysReportApi = {
  list: (params) => api.get('/sysreport', { params }),
  get: (srpId) => api.get(`/sysreport/${srpId}`),
  create: (data) => api.post('/sysreport', data),
  update: (srpId, data) => api.put(`/sysreport/${srpId}`, data),
  remove: (srpId) => api.delete(`/sysreport/${srpId}`),
  copy: (srpId, data) => api.post(`/sysreport/${srpId}/copy`, data),

  getReportFile: (srpId) => api.get(`/sysreport/${srpId}/reportfile`),
  saveReportFile: (srpId, srpReportfile) =>
    api.put(`/sysreport/${srpId}/reportfile`, { srp_reportfile: srpReportfile }),

  listFields: (srpId) => api.get(`/sysreport/${srpId}/fields`),
  createField: (srpId, data) => api.post(`/sysreport/${srpId}/fields`, data),
  updateField: (srpId, srfSeqno, data) => api.put(`/sysreport/${srpId}/fields/${srfSeqno}`, data),
  removeField: (srpId, srfSeqno) => api.delete(`/sysreport/${srpId}/fields/${srfSeqno}`),
  getSelectColumns: (srpId) => api.get(`/sysreport/${srpId}/select-columns`),
  getFieldLookupData: (srpId, srfSeqno, q) =>
    api.get(`/sysreport/${srpId}/fields/${srfSeqno}/lookup-data`, { params: { q: q || undefined } }),

  getQueryMeta: (srpId) => api.get(`/sysreport/${srpId}/query-meta`),
  queryUrl: (srpId, criteria, orderby) => {
    const params = new URLSearchParams()
    if (criteria) params.set('criteria', JSON.stringify(criteria))
    if (orderby) params.set('orderby', JSON.stringify(orderby))
    return `/api/sysreport/${srpId}/query?${params.toString()}`
  },
  runQuery: (srpId, criteria, orderby, limit) =>
    api.get(`/sysreport/${srpId}/query`, {
      params: {
        criteria: criteria ? JSON.stringify(criteria) : undefined,
        orderby: orderby ? JSON.stringify(orderby) : undefined,
        limit: limit || undefined,
      },
    }),
}

import { useEffect, useState } from 'react'
import { FileTextOutlined, BarChartOutlined, LineChartOutlined } from '@ant-design/icons'
import { sysReportApi } from '../api/sysreport'

// 首頁/側邊選單的 3 個報表模組，功能項目來自 TBLSYSREPORT，依 SRP_CODE 前綴分組，
// 不用手動維護清單——系統報表新增/刪除，這裡自動跟著變。
const PREFIX_MODULES = [
  { prefix: 'FM_', key: 'report-form', label: '表單報表模組', icon: FileTextOutlined },
  { prefix: 'MG_', key: 'report-management', label: '管理報表模組', icon: BarChartOutlined },
  { prefix: 'ST_', key: 'report-statistics', label: '統計報表模組', icon: LineChartOutlined },
]

export function useReportModules() {
  const [modules, setModules] = useState(
    PREFIX_MODULES.map((m) => ({ ...m, children: [], loading: true }))
  )

  useEffect(() => {
    let cancelled = false
    sysReportApi.list({ page_size: 500 })
      .then((res) => {
        if (cancelled) return
        const rows = res.data?.data || []
        setModules(
          PREFIX_MODULES.map((m) => ({
            ...m,
            loading: false,
            children: rows
              .filter((r) => r.srp_code.startsWith(m.prefix))
              .sort((a, b) => a.srp_code.localeCompare(b.srp_code))
              .map((r) => ({
                key: `report-view-${r.srp_id}`,
                label: `${r.srp_name}（${r.srp_code}）`,
                path: `/report/view/${r.srp_id}`,
                icon: FileTextOutlined,
                ready: true,
              })),
          }))
        )
      })
      .catch(() => {
        if (!cancelled) {
          setModules(PREFIX_MODULES.map((m) => ({ ...m, children: [], loading: false })))
        }
      })
    return () => { cancelled = true }
  }, [])

  return modules
}

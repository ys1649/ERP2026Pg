import { useEffect, useRef, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { Alert, Button, Card, Spin, message, Typography } from 'antd'
import { ArrowLeftOutlined, InfoCircleOutlined } from '@ant-design/icons'
import { sysReportApi } from '../api/sysreport'

const DESIGNER_ID = 'sti-sysreport-designer-root'

function waitForStimulsoft(timeoutMs = 5000) {
  return new Promise((resolve, reject) => {
    const start = Date.now()
    const check = () => {
      if (window.Stimulsoft) return resolve(window.Stimulsoft)
      if (Date.now() - start > timeoutMs) return reject(new Error('Stimulsoft 未載入'))
      setTimeout(check, 200)
    }
    check()
  })
}

// 用整頁路由而非 AntD Modal 承載 Stimulsoft Designer：實測發現包在 Modal 裡時，
// 從 Dictionary 拖曳欄位到 band 上，元件最終位置會被算錯、跑到版面極遠處（Modal 外的
// 座標計算被干擾），拆成獨立頁面後這個問題就消失了。
export default function SysReportDesignerPage() {
  const { srpId: srpIdParam } = useParams()
  const srpId = Number(srpIdParam)
  const navigate = useNavigate()

  const [report, setReport] = useState(null)
  const [loading, setLoading] = useState(true)
  const [stimulsoftReady, setStimulsoftReady] = useState(false)
  const [notInstalled, setNotInstalled] = useState(false)
  const designerRef = useRef(null)
  const designerDivRef = useRef(null)

  useEffect(() => {
    sysReportApi.get(srpId).then((res) => setReport(res.data)).catch(() => message.error('載入報表資料失敗'))
  }, [srpId])

  useEffect(() => {
    waitForStimulsoft(5000)
      .then(() => setStimulsoftReady(true))
      .catch(() => setNotInstalled(true))
  }, [])

  useEffect(() => {
    if (!stimulsoftReady || !srpId) return
    const container = designerDivRef.current
    if (!container) return

    let cancelled = false
    setLoading(true)
    const S = window.Stimulsoft

    Promise.all([
      sysReportApi.getReportFile(srpId),
      sysReportApi.runQuery(srpId, null, null, 20).then((res) => ({ ok: true, rows: res.data })).catch((error) => ({ ok: false, error })),
    ])
      .then(([fileRes, queryResult]) => {
      if (cancelled) return
      try {
        const options = new S.Designer.StiDesignerOptions()
        options.appearance.fullScreenMode = false
        options.appearance.showSaveButton = true

        const designer = new S.Designer.StiDesigner(options, 'SysReportDesigner', false)
        const stiReport = new S.Report.StiReport()

        const saved = fileRes.data?.srp_reportfile
        let loaded = false
        if (saved && saved.trim().startsWith('{')) {
          try {
            stiReport.load(saved)
            loaded = true
          } catch (parseErr) {
            console.error('[SysReportDesignerPage] 版面內容非合法 JSON，忽略並視為尚未設計:', parseErr)
            message.warning('已儲存的報表版面內容毀損，將視為尚未設計版面')
          }
        }
        // 已儲存的版面只保留資料來源的欄位結構，不含實際資料列，
        // 每次開啟都要用目前查詢結果重新灌入，Preview 才看得到資料
        const sampleRows = queryResult.ok ? queryResult.rows : null
        if (Array.isArray(sampleRows) && sampleRows.length > 0) {
          const dataSet = new S.System.Data.DataSet('root')
          dataSet.readJson(JSON.stringify(sampleRows))
          stiReport.regData('root', 'root', dataSet, true)
        } else if (!loaded) {
          if (!queryResult.ok) {
            const detail = queryResult.error?.response?.data?.detail || queryResult.error?.message || '未知錯誤'
            message.error(`報表查詢執行失敗，無法自動帶入欄位：${detail}`, 8)
          } else {
            message.warning('目前查詢欄位皆留空時查不到任何資料，無法自動帶入欄位，請先在查詢欄位設定合理的預設值，或手動於左側 Data Sources 新增欄位。')
          }
          const conn = new S.Report.Dictionary.StiJsonDatabase()
          conn.name = 'root'
          conn.alias = 'root'
          conn.pathData = sysReportApi.queryUrl(srpId)
          stiReport.dictionary.databases.add(conn)
        }

        designer.report = stiReport

        designer.onSaveReport = (args) => {
          const json = args.report.saveToJsonString()
          sysReportApi.saveReportFile(srpId, json)
            .then(() => message.success('報表版面已儲存'))
            .catch(() => message.error('報表版面儲存失敗'))
        }

        container.innerHTML = ''
        designer.renderHtml(DESIGNER_ID)
        designerRef.current = designer
      } catch (e) {
        console.error('[SysReportDesignerPage] init error:', e)
        message.error('設計器初始化失敗：' + e.message)
      } finally {
        setLoading(false)
      }
    }).catch(() => {
      if (!cancelled) {
        message.error('載入報表版面失敗')
        setLoading(false)
      }
    })

    return () => {
      cancelled = true
      if (designerDivRef.current) designerDivRef.current.innerHTML = ''
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [stimulsoftReady, srpId])

  return (
    <Card
      title={
        <span>
          <Button
            type="text"
            icon={<ArrowLeftOutlined />}
            onClick={() => navigate('/system/report')}
            style={{ marginRight: 8 }}
          />
          設計報表版面 — {report?.srp_name ?? ''} ({report?.srp_code ?? ''})
        </span>
      }
      styles={{ body: { padding: notInstalled ? 24 : 0 } }}
    >
      {notInstalled ? (
        <Alert
          type="warning"
          showIcon
          icon={<InfoCircleOutlined />}
          message="Stimulsoft Reports.JS 未載入"
          description={
            <div>
              <p>請依下列步驟安裝 Stimulsoft：</p>
              <Typography.Text code>cd frontend &amp;&amp; npm install</Typography.Text>
            </div>
          }
        />
      ) : (
        <Spin spinning={loading} tip="載入中...">
          <div ref={designerDivRef} id={DESIGNER_ID} style={{ height: 'calc(100vh - 200px)', minHeight: 500 }} />
        </Spin>
      )}
    </Card>
  )
}

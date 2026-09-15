import { useState, useEffect, useRef } from 'react'
import { createPortal } from 'react-dom'
import { useNavigate } from 'react-router-dom'
import { Card, Form, DatePicker, Button, Space, Typography, Modal, Spin, notification } from 'antd'
import { PieChartOutlined, SearchOutlined, CloseOutlined, RollbackOutlined } from '@ant-design/icons'
import dayjs from 'dayjs'
import { glReportsApi } from '../api/glReports'
import { sysReportApi } from '../api/sysreport'

const { Title } = Typography

// GL_ASSET 這筆系統報表定義的 SRP_ID（backend/scripts/create_gl_reports.py 建立，ID 已固定不會變動），
// 這裡只借用它存的 Stimulsoft 版面（SRP_REPORTFILE），資料來源改走專屬的 /api/gl-reports/asset。
const GL_ASSET_SRP_ID = 69
const VIEWER_ID = 'sti-asset-liability-viewer'

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

export default function AssetLiabilityStatement() {
  const navigate = useNavigate()
  const [form] = Form.useForm()
  const [previewOpen, setPreviewOpen] = useState(false)
  const [previewLoading, setPreviewLoading] = useState(false)
  const [stimulsoftReady, setStimulsoftReady] = useState(false)
  const viewerDivRef = useRef(null)
  const cancelledRef = useRef(false)

  useEffect(() => {
    waitForStimulsoft(5000).then(() => setStimulsoftReady(true)).catch(() => {})
  }, [])

  const handlePreview = async () => {
    const values = await form.validateFields()
    const dtEnd = values.dt_end.format('YYYY-MM-DD')

    if (!stimulsoftReady) {
      notification.error({ message: '錯誤', description: 'Stimulsoft 未載入，請先執行 npm install', duration: 4 })
      return
    }

    setPreviewOpen(true)
    setPreviewLoading(true)
    cancelledRef.current = false

    try {
      const [reportRes, dataRes] = await Promise.all([
        sysReportApi.getReportFile(GL_ASSET_SRP_ID),
        glReportsApi.asset(dtEnd),
      ])
      if (cancelledRef.current) return

      const saved = reportRes.data?.srp_reportfile
      if (!saved || !saved.trim().startsWith('{')) {
        message_warning()
        setPreviewOpen(false)
        return
      }

      const S = window.Stimulsoft
      const reportJson = JSON.parse(saved)
      reportJson.ReportGuid = Date.now().toString(36) + Math.random().toString(36).slice(2)
      const report = new S.Report.StiReport()
      report.load(JSON.stringify(reportJson))

      const dataSet = new S.System.Data.DataSet('root')
      dataSet.readJson(JSON.stringify({ root: dataRes.data.rows }))
      report.regData('root', 'root', dataSet)

      const metaDataSet = new S.System.Data.DataSet('srpmeta')
      metaDataSet.readJson(JSON.stringify({
        srpmeta: [{
          srp_id: GL_ASSET_SRP_ID,
          srp_code: 'GL_ASSET',
          srp_name: '資產負債表',
          srp_description: `傳票日期 ${dataRes.data.dt_from} ~ ${dataRes.data.dt_end}`,
          cor_name: dataRes.data.cor_name || '',
          // 故意格式化成中文日期（不是 ISO 格式），避免 Stimulsoft 的 DataSet.readJson()
          // 把長得像日期的字串自動轉型成內部 DateTime（會牽扯到時區換算，導致日期跟原始
          // 輸入差一天，而且預設 ToString 還會多印出時分秒）
          dt_end: dayjs(dataRes.data.dt_end).format('YYYY年MM月DD日'),
        }],
      }))
      report.regData('srpmeta', 'srpmeta', metaDataSet)

      const viewerOptions = new S.Viewer.StiViewerOptions()
      viewerOptions.appearance.fullScreenMode = true
      viewerOptions.width = '100%'
      viewerOptions.height = '100%'
      viewerOptions.exports.showExportToPdf = true
      viewerOptions.exports.showExportToExcel2007 = true
      viewerOptions.toolbar.showSendEmailButton = false
      const viewer = new S.Viewer.StiViewer(viewerOptions, 'AssetLiabilityViewer', false)

      report.renderAsync(() => {
        if (cancelledRef.current) return
        viewer.report = report
        if (viewerDivRef.current) {
          viewerDivRef.current.innerHTML = ''
          viewer.renderHtml(VIEWER_ID)
        }
      })
    } catch (err) {
      notification.error({ message: '錯誤', description: err.response?.data?.detail || err.message || '預覽失敗', duration: 4 })
      setPreviewOpen(false)
    } finally {
      if (!cancelledRef.current) setPreviewLoading(false)
    }
  }

  const message_warning = () => {
    notification.warning({ message: '尚未設計版面', description: '請先至「系統報表管理」找 GL_ASSET，點「設計」建立版面。', duration: 5 })
  }

  const closePreview = () => {
    cancelledRef.current = true
    setPreviewOpen(false)
    if (viewerDivRef.current) viewerDivRef.current.innerHTML = ''
    document.documentElement.style.overflow = ''
    document.body.style.overflow = ''
  }

  return (
    <>
      <Card style={{ maxWidth: 420, margin: '40px auto' }}>
        <Space direction="vertical" size="middle" style={{ width: '100%' }}>
          <Space>
            <PieChartOutlined style={{ fontSize: 28, color: '#1677ff' }} />
            <Title level={4} style={{ margin: 0 }}>資產負債表</Title>
          </Space>
          <Form form={form} layout="horizontal" labelCol={{ span: 9 }} initialValues={{ dt_end: dayjs() }}>
            <Form.Item name="dt_end" label="傳票截止日期" rules={[{ required: true, message: '必填' }]}>
              <DatePicker style={{ width: '100%' }} />
            </Form.Item>
          </Form>
          <Space style={{ width: '100%', justifyContent: 'center' }}>
            <Button type="primary" icon={<SearchOutlined />} onClick={handlePreview}>預覽</Button>
            <Button icon={<RollbackOutlined />} onClick={() => navigate('/')}>離開</Button>
          </Space>
        </Space>
      </Card>

      <Modal
        open={previewOpen}
        onCancel={closePreview}
        title={null}
        footer={null}
        closable={false}
        width="100vw"
        style={{ top: 0, padding: 0, margin: 0, maxWidth: 'none' }}
        styles={{ content: { padding: 0, borderRadius: 0 }, body: { padding: 0, height: '100vh', overflow: 'hidden' } }}
        destroyOnHidden
      >
        <div style={{ position: 'relative', height: '100vh', overflow: 'hidden' }}>
          {previewOpen && createPortal(
            <Button
              type="text"
              size="small"
              icon={<CloseOutlined />}
              onClick={closePreview}
              style={{
                position: 'fixed', top: 6, right: 64, zIndex: 2000000,
                background: '#fff', boxShadow: '0 0 4px rgba(0,0,0,0.25)',
              }}
            >
              關閉
            </Button>,
            document.body
          )}
          {previewLoading && (
            <div style={{
              position: 'absolute', inset: 0, zIndex: 5, display: 'flex',
              alignItems: 'center', justifyContent: 'center', background: 'rgba(255,255,255,0.6)',
            }}>
              <Spin tip="報表產生中..." />
            </div>
          )}
          <div ref={viewerDivRef} id={VIEWER_ID} style={{ height: '100vh' }} />
        </div>
      </Modal>
    </>
  )
}

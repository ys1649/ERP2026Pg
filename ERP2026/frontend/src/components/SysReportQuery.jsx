import { useState, useEffect, useCallback, useRef, forwardRef, useImperativeHandle } from 'react'
import { createPortal } from 'react-dom'
import {
  Card, Row, Col, Space, Input, InputNumber, DatePicker, Select, Button,
  List, Modal, message, notification, Spin, Empty, Typography,
} from 'antd'
import {
  SearchOutlined, CloseCircleOutlined, CloseOutlined, ArrowUpOutlined, ArrowDownOutlined,
  SortAscendingOutlined, SortDescendingOutlined,
} from '@ant-design/icons'
import dayjs from 'dayjs'
import { sysReportApi } from '../api/sysreport'
import SysReportFieldPicker from './SysReportFieldPicker'

const { Text } = Typography
const VIEWER_ID_PREFIX = 'sti-sysreport-query-viewer'

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

function QueryField({ srpId, field, value, onChange }) {
  const isRange = field.srf_querytype === 'Range'
  const isMulti = field.srf_querytype === 'MultiSelect'
  const clear = () => onChange(isRange ? { from: undefined, to: undefined } : undefined)

  const renderControl = (v, onV, placeholder) => {
    if (field.srf_controltype === 'SQL') {
      return <SysReportFieldPicker srpId={srpId} field={field} value={v} onChange={onV} />
    }
    switch (field.srf_controltype) {
      case 'Date':
        return (
          <DatePicker
            style={{ width: '100%' }}
            value={v ? dayjs(v) : null}
            onChange={(d) => onV(d ? d.format('YYYY-MM-DD') : undefined)}
            placeholder={placeholder}
          />
        )
      case 'ListItem':
        return (
          <Select
            allowClear
            style={{ width: '100%' }}
            value={v ?? undefined}
            onChange={(sel) => onV(sel)}
            options={(field.srf_list_value || '').split(',').filter(Boolean).map((o) => ({ label: o, value: o }))}
            placeholder={placeholder}
          />
        )
      default:
        return field.srf_datatype === 'Numberic' ? (
          <InputNumber
            style={{ width: '100%' }}
            value={v ?? null}
            onChange={(n) => onV(n ?? undefined)}
            placeholder={placeholder}
          />
        ) : (
          <Input
            value={v ?? ''}
            onChange={(e) => onV(e.target.value || undefined)}
            placeholder={placeholder}
          />
        )
    }
  }

  return (
    <Row gutter={4} align="middle" style={{ marginBottom: 10 }}>
      <Col span={7}>
        <Text>
          {field.srf_dispname}
          {!!field.srf_ismustcriteria && <Text type="danger"> *</Text>}
        </Text>
      </Col>
      <Col span={15}>
        {isRange ? (
          <Space.Compact style={{ width: '100%' }}>
            {renderControl(value?.from, (v) => onChange({ ...value, from: v }), '起')}
            {renderControl(value?.to, (v) => onChange({ ...value, to: v }), '迄')}
          </Space.Compact>
        ) : isMulti ? (
          <SysReportFieldPicker srpId={srpId} field={field} value={value} onChange={onChange} />
        ) : (
          renderControl(value, onChange, undefined)
        )}
      </Col>
      <Col span={2}>
        <Button type="text" size="small" icon={<CloseCircleOutlined />} onClick={clear} title="清除" />
      </Col>
    </Row>
  )
}

const SysReportQuery = forwardRef(function SysReportQuery({ srpId }, ref) {
  const [meta, setMeta] = useState(null)
  const [loadingMeta, setLoadingMeta] = useState(false)
  const [values, setValues] = useState({})
  const [orderby, setOrderby] = useState([])
  const [stimulsoftReady, setStimulsoftReady] = useState(false)

  const [previewOpen, setPreviewOpen] = useState(false)
  const [previewModalVisible, setPreviewModalVisible] = useState(false)
  const [previewLoading, setPreviewLoading] = useState(false)
  const [previewParams, setPreviewParams] = useState(null)
  const viewerDivRef = useRef(null)
  const viewerId = `${VIEWER_ID_PREFIX}-${srpId}`

  useEffect(() => {
    waitForStimulsoft(5000).then(() => setStimulsoftReady(true)).catch(() => {})
  }, [])

  useEffect(() => {
    if (!srpId) return
    setLoadingMeta(true)
    sysReportApi.getQueryMeta(srpId)
      .then((res) => {
        setMeta(res.data)
        setValues({})
        setOrderby(res.data.orderby_default.map((o) => ({ ...o })))
      })
      .catch((err) => {
        console.log('[SysReportQuery] 載入報表定義失敗', err)
        notification.error({ message: '錯誤', description: err.response?.data?.detail || '載入報表定義失敗', duration: 4 })
      })
      .finally(() => setLoadingMeta(false))
  }, [srpId])

  const moveOrderby = (idx, dir) => {
    setOrderby((prev) => {
      const next = [...prev]
      const target = idx + dir
      if (target < 0 || target >= next.length) return prev
      ;[next[idx], next[target]] = [next[target], next[idx]]
      return next
    })
  }

  const toggleDir = (idx) => {
    setOrderby((prev) => prev.map((o, i) => (i === idx ? { ...o, dir: o.dir === 'ASC' ? 'DESC' : 'ASC' } : o)))
  }

  const buildCriteria = () => {
    const fields = meta?.fields || []
    for (const f of fields) {
      const v = values[f.srf_seqno]
      if (f.srf_ismustcriteria) {
        const empty = f.srf_querytype === 'Range' ? (!v?.from && !v?.to)
          : f.srf_querytype === 'MultiSelect' ? !(v && v.length)
          : !v
        if (empty) {
          message.warning(`「${f.srf_dispname}」為必要條件，請輸入`)
          return null
        }
      }
    }
    return fields.map((f) => {
      const v = values[f.srf_seqno]
      if (f.srf_querytype === 'Range') return { srf_seqno: f.srf_seqno, value_from: v?.from, value_to: v?.to }
      if (f.srf_querytype === 'MultiSelect') return { srf_seqno: f.srf_seqno, values: v || [] }
      return { srf_seqno: f.srf_seqno, value: v }
    })
  }

  const handlePreview = useCallback(() => {
    if (!srpId) return
    const criteria = buildCriteria()
    if (!criteria) return
    setPreviewParams({ criteria, orderby: [...orderby] })
    setPreviewOpen(true)
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [srpId, values, orderby])

  useImperativeHandle(ref, () => ({ preview: handlePreview }), [handlePreview])

  useEffect(() => {
    if (!previewModalVisible || !previewParams || !srpId) return
    const container = viewerDivRef.current
    if (!container) return

    let cancelled = false
    setPreviewLoading(true)

    async function run() {
      if (!stimulsoftReady) {
        notification.error({ message: '錯誤', description: 'Stimulsoft 未載入，請先執行 npm install', duration: 4 })
        return
      }
      if (!meta) {
        notification.error({ message: '錯誤', description: '報表定義尚未載入完成，請稍後再試', duration: 4 })
        return
      }
      const S = window.Stimulsoft
      const fileRes = await sysReportApi.getReportFile(srpId)
      const saved = fileRes.data?.srp_reportfile
      if (!saved || !saved.trim().startsWith('{')) {
        message.warning('此報表尚未設計版面，請先至「系統報表定義」點選「設計」建立版面。')
        return
      }
      const reportJson = JSON.parse(saved)
      reportJson.ReportGuid = Date.now().toString(36) + Math.random().toString(36).slice(2)
      const report = new S.Report.StiReport()
      report.load(JSON.stringify(reportJson))

      const dataRes = await sysReportApi.runQuery(srpId, previewParams.criteria, previewParams.orderby)
      if (cancelled) return
      const dataSet = new S.System.Data.DataSet('root')
      // 注意：readJson 餵「純陣列」時，Stimulsoft 底層一律把資料表命名為固定的
      // "root"，不管 DataSet 建構子給的名字是什麼；一定要用 {表名: rows} 包一層，
      // 否則會跟下面 srpmeta 的資料表撞名，導致欄位綁定時好時壞。
      dataSet.readJson(JSON.stringify({ root: dataRes.data }))
      report.regData('root', 'root', dataSet)

      // 比照設計器灌入 srpmeta，讓版面上綁定的 SRP_NAME 等欄位預覽/列印時有值
      const metaDataSet = new S.System.Data.DataSet('srpmeta')
      metaDataSet.readJson(JSON.stringify({
        srpmeta: [{
          srp_id: meta.srp_id,
          srp_code: meta.srp_code,
          srp_name: meta.srp_name,
          srp_description: meta.srp_description,
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
      const viewer = new S.Viewer.StiViewer(viewerOptions, `SysReportViewer_${srpId}`, false)

      report.renderAsync(() => {
        if (cancelled) return
        viewer.report = report
        if (viewerDivRef.current) {
          viewerDivRef.current.innerHTML = ''
          viewer.renderHtml(viewerId)
        }
      })
    }

    run()
      .catch((err) => {
        console.log('[SysReportQuery] preview error', err, err.response?.data)
        notification.error({ message: '錯誤', description: err.response?.data?.detail || err.message || '預覽失敗', duration: 4 })
      })
      .finally(() => {
        if (!cancelled) setPreviewLoading(false)
      })

    return () => {
      cancelled = true
      if (viewerDivRef.current) viewerDivRef.current.innerHTML = ''
      // fullScreenMode 會直接把 document.body/html 設成 overflow: hidden 供內部捲動用，
      // 關閉 Modal 時要還原，否則整個畫面會卡住無法捲動，需重新整理頁面才會恢復。
      document.documentElement.style.overflow = ''
      document.body.style.overflow = ''
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [previewModalVisible, previewParams, srpId, stimulsoftReady])

  if (loadingMeta) return <Spin />
  if (!meta) return <Empty description="請選擇系統報表" />

  return (
    <>
      <Row gutter={16}>
        <Col span={16}>
          <Card title="查詢條件" size="small" style={{ marginBottom: 16 }}>
            {(meta.fields || []).length === 0 ? (
              <Empty description="尚未定義查詢欄位" />
            ) : (
              meta.fields.map((f) => (
                <QueryField
                  key={f.srf_seqno}
                  srpId={srpId}
                  field={f}
                  value={values[f.srf_seqno]}
                  onChange={(v) => setValues((prev) => ({ ...prev, [f.srf_seqno]: v }))}
                />
              ))
            )}
          </Card>
        </Col>
        <Col span={8}>
          <Card title="排序欄位" size="small" style={{ marginBottom: 16 }}>
            {orderby.length === 0 ? (
              <Empty description="未設定排序欄位" />
            ) : (
              <List
                size="small"
                dataSource={orderby}
                renderItem={(o, idx) => (
                  <List.Item
                    actions={[
                      <Button key="dir" type="text" size="small"
                        icon={o.dir === 'DESC' ? <SortDescendingOutlined /> : <SortAscendingOutlined />}
                        onClick={() => toggleDir(idx)}>{o.dir}</Button>,
                      <Button key="up" type="text" size="small" icon={<ArrowUpOutlined />}
                        disabled={idx === 0} onClick={() => moveOrderby(idx, -1)} />,
                      <Button key="down" type="text" size="small" icon={<ArrowDownOutlined />}
                        disabled={idx === orderby.length - 1} onClick={() => moveOrderby(idx, 1)} />,
                    ]}
                  >
                    {o.disp}
                  </List.Item>
                )}
              />
            )}
          </Card>
        </Col>
      </Row>

      <Modal
        open={previewOpen}
        onCancel={() => setPreviewOpen(false)}
        afterOpenChange={(visible) => setPreviewModalVisible(visible)}
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
              onClick={() => setPreviewOpen(false)}
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
          <div ref={viewerDivRef} id={viewerId} style={{ height: '100vh' }} />
        </div>
      </Modal>
    </>
  )
})

export default SysReportQuery

export function SysReportQueryModal({ open, srpId, title, onCancel }) {
  const queryRef = useRef(null)
  return (
    <Modal
      title={title || '系統報表查詢'}
      open={open}
      onCancel={onCancel}
      footer={
        <Button type="primary" icon={<SearchOutlined />} onClick={() => queryRef.current?.preview()}>
          預覽
        </Button>
      }
      width="95vw"
      style={{ top: 16 }}
      destroyOnHidden
    >
      {open && <SysReportQuery ref={queryRef} srpId={srpId} />}
    </Modal>
  )
}

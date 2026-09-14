import { useState, useEffect, useCallback, useRef, useLayoutEffect } from 'react'
import {
  Modal, Form, Input, InputNumber, DatePicker, Button, Space,
  Table, message, Tag, Typography, Row, Col,
} from 'antd'
import {
  SaveOutlined, CloseOutlined, EditOutlined, DeleteOutlined,
  CheckCircleOutlined, UndoOutlined, DollarOutlined, HistoryOutlined,
  PlusOutlined, CloseCircleOutlined,
} from '@ant-design/icons'
import Draggable from 'react-draggable'
import { Resizable } from 'react-resizable'
import 'react-resizable/css/styles.css'
import dayjs from 'dayjs'
import { poRecvApi } from '../api/poRecv'
import { supplierApi } from '../api/suppliers'
import { DDLookup } from '../lib/ddLookup'
import { SearchSelect } from './SearchSelect'

const { Text } = Typography
const { TextArea } = Input

const DEFAULT_SIZE = { width: 960, height: 640 }
const MIN_SIZE = { width: 700, height: 460 }
const ITEM_STYLE = { marginBottom: 8 }

const HIST_DEFAULT_SIZE = { width: 900, height: 560 }
const HIST_MIN_SIZE = { width: 640, height: 420 }
const HIST_DARK_CSS = `
.porecv-hist-dark .ant-table { background: transparent; }
.porecv-hist-dark .ant-table-thead > tr > th { background: #092f22; color: #fff; border-bottom: 1px solid #1f5c46; }
.porecv-hist-dark .ant-table-tbody > tr { background: #0b3d2e; }
.porecv-hist-dark .ant-table-tbody > tr > td { background: transparent; color: #fff; border-bottom: 1px solid #1f5c46; }
.porecv-hist-dark .ant-table-tbody > tr.porecv-hist-row-selected > td { background: #1f7a4d !important; }
.porecv-hist-dark .ant-table-tbody > tr:hover:not(.porecv-hist-row-selected) > td { background: rgba(255,255,255,0.12) !important; }
.porecv-hist-dark .ant-table-placeholder > td { background: transparent !important; color: rgba(255,255,255,0.65) !important; }
.porecv-hist-dark .ant-empty-description { color: rgba(255,255,255,0.65) !important; }
`

const STATUS_TAG = { 0: <Tag color="orange">未確認</Tag>, 1: <Tag color="green">已確認</Tag> }

export default function PoRecvFormModal({ open, rcvNo, onClose }) {
  const [activeRcvNo, setActiveRcvNo] = useState(rcvNo)
  const isNew = activeRcvNo === 'new'
  const [form] = Form.useForm()
  const [mode, setMode] = useState('view')
  const [header, setHeader] = useState(null)
  const [lines, setLines] = useState([])
  const [loading, setLoading] = useState(false)
  const [saving, setSaving] = useState(false)
  const [addingLines, setAddingLines] = useState(false)
  const [seq, setSeq] = useState(0)

  const [qpOpen, setQpOpen] = useState(false)
  const [qpForm] = Form.useForm()
  const [qpSaving, setQpSaving] = useState(false)

  const [histOpen, setHistOpen] = useState(false)
  const [histData, setHistData] = useState([])
  const [histSelectedNo, setHistSelectedNo] = useState(null)
  const [histLines, setHistLines] = useState([])
  const [histLinesLoading, setHistLinesLoading] = useState(false)
  const [histSize, setHistSize] = useState(HIST_DEFAULT_SIZE)
  const [histDragDisabled, setHistDragDisabled] = useState(true)
  const [histBounds, setHistBounds] = useState({ left: 0, top: 0, right: 0, bottom: 0 })
  const histDraggleRef = useRef(null)
  const histMasterWrapRef = useRef(null)
  const histDetailWrapRef = useRef(null)
  const [histMasterScrollY, setHistMasterScrollY] = useState(200)
  const [histDetailScrollY, setHistDetailScrollY] = useState(160)

  // ── 拖曳 + 縮放（比照 ShipFormModal 已建立的模式） ──
  const [size, setSize] = useState(DEFAULT_SIZE)
  const [dragDisabled, setDragDisabled] = useState(true)
  const [bounds, setBounds] = useState({ left: 0, top: 0, right: 0, bottom: 0 })
  const draggleRef = useRef(null)
  const titleRef = useRef(null)
  const headerRef = useRef(null)
  const footerRef = useRef(null)
  const [bodyHeight, setBodyHeight] = useState(240)

  useEffect(() => {
    if (open) setSize(DEFAULT_SIZE)
  }, [open])

  const recomputeBodyHeight = useCallback(() => {
    const t = titleRef.current?.offsetHeight || 0
    const h = headerRef.current?.offsetHeight || 0
    const f = footerRef.current?.offsetHeight || 0
    setBodyHeight(Math.max(120, size.height - t - h - f - 16))
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [size.height, size.width])

  useLayoutEffect(() => { recomputeBodyHeight() }, [recomputeBodyHeight, lines.length, mode])

  const onDragStart = (_e, uiData) => {
    const targetRect = draggleRef.current?.getBoundingClientRect()
    if (!targetRect) return
    setBounds({
      left: -targetRect.left + uiData.x,
      right: window.innerWidth - (targetRect.right - uiData.x),
      top: -targetRect.top + uiData.y,
      bottom: window.innerHeight - (targetRect.bottom - uiData.y),
    })
  }

  const modalRender = (modalNode) => (
    <Draggable
      disabled={dragDisabled}
      bounds={bounds}
      nodeRef={draggleRef}
      onStart={onDragStart}
      handle=".porecv-modal-title-bar"
    >
      <div ref={draggleRef}>{modalNode}</div>
    </Draggable>
  )

  const load = useCallback(async (targetRcvNo) => {
    if (targetRcvNo === 'new') {
      setHeader(null)
      setLines([])
      setSeq(0)
      form.resetFields()
      form.setFieldsValue({ rcv_date: dayjs(), rcv_tax: 0 })
      setMode('create')
      return
    }
    setLoading(true)
    try {
      const res = await poRecvApi.get(targetRcvNo)
      setHeader(res.data)
      setLines(res.data.lines.map((l, i) => ({ ...l, _key: i })))
      setSeq(res.data.lines.length)
      form.setFieldsValue({ ...res.data, rcv_date: dayjs(res.data.rcv_date) })
      setMode('view')
    } catch {
      message.error('載入進貨單失敗')
      onClose()
    } finally {
      setLoading(false)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [form])

  useEffect(() => {
    if (!open) return
    setActiveRcvNo(rcvNo)
    load(rcvNo)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, rcvNo, load])

  const editing = mode === 'edit' || mode === 'create'
  const total = lines.reduce((s, l) => s + (Number(l.rcd_qty) || 0) * (Number(l.rcd_unit_price) || 0), 0)
  const currentTax = Form.useWatch('rcv_tax', form) ?? header?.rcv_tax ?? 0
  const currentSupNo = Form.useWatch('sup_no', form)

  const updateLine = (key, patch) => {
    setLines((prev) => prev.map((l) => (l._key === key ? { ...l, ...patch } : l)))
  }

  const handleRemoveLine = (key) => setLines((prev) => prev.filter((l) => l._key !== key))

  const handleAddLines = async () => {
    const result = await DDLookup.getDDLookup('TBL_PRODUCT')
    if (!result || result.rows.length === 0) return
    setAddingLines(true)
    try {
      const supNo = form.getFieldValue('sup_no')
      const startKey = seq
      const enriched = await Promise.all(result.rows.map(async (row, i) => {
        const priceRes = supNo
          ? await poRecvApi.price(supNo, row.prd_no).catch(() => ({ data: { price: 0 } }))
          : { data: { price: 0 } }
        return {
          _key: startKey + i,
          prd_no: row.prd_no,
          prd_name: row.prd_name,
          prd_onhand: row.prd_onhand,
          rcd_unit_price: priceRes.data.price,
          rcd_qty: 1,
        }
      }))
      setSeq(startKey + enriched.length)
      setLines((prev) => [...prev, ...enriched])
    } finally {
      setAddingLines(false)
    }
  }

  const handleEdit = () => setMode('edit')
  const handleAbort = () => {
    if (isNew) { onClose(); return }
    load(activeRcvNo)
  }

  const requestClose = () => {
    if (editing) {
      message.warning('正在新增或修改中，請先存檔或放棄')
      return
    }
    onClose()
  }

  const handleSave = async () => {
    try {
      const values = await form.validateFields()
      if (lines.length === 0) { message.error('至少需要一筆品項'); return }
      const payload = {
        sup_no: values.sup_no,
        rcv_inv_no: values.rcv_inv_no || null,
        rcv_date: values.rcv_date.format('YYYY-MM-DD'),
        rcv_tax: values.rcv_tax || 0,
        rcv_desc: values.rcv_desc || null,
        lines: lines.map((l) => ({
          prd_no: l.prd_no,
          rcd_unit_price: Number(l.rcd_unit_price) || 0,
          rcd_qty: Number(l.rcd_qty) || 0,
        })),
      }
      setSaving(true)
      if (isNew) {
        const res = await poRecvApi.create(payload)
        message.success('新增成功')
        setActiveRcvNo(res.data.rcv_no)
        await load(res.data.rcv_no)
      } else {
        await poRecvApi.update(activeRcvNo, payload)
        message.success('更新成功')
        await load(activeRcvNo)
      }
    } catch (err) {
      if (err?.errorFields) return
      message.error(err.response?.data?.detail || '儲存失敗')
    } finally {
      setSaving(false)
    }
  }

  const handleDelete = () => {
    Modal.confirm({
      title: `確定刪除進貨單「${activeRcvNo}」？`,
      okText: '刪除',
      okButtonProps: { danger: true },
      cancelText: '取消',
      onOk: async () => {
        try {
          await poRecvApi.remove(activeRcvNo)
          message.success('刪除成功')
          onClose()
        } catch (err) {
          message.error(err.response?.data?.detail || '刪除失敗')
        }
      },
    })
  }

  const handleBook = async () => {
    try {
      await poRecvApi.book(activeRcvNo)
      message.success('確認成功')
      load(activeRcvNo)
    } catch (err) {
      message.error(err.response?.data?.detail || '確認失敗')
    }
  }

  const handleUnbook = async () => {
    try {
      await poRecvApi.unbook(activeRcvNo)
      message.success('取消確認成功')
      load(activeRcvNo)
    } catch (err) {
      message.error(err.response?.data?.detail || '取消確認失敗')
    }
  }

  const openQuickPay = () => {
    qpForm.resetFields()
    qpForm.setFieldsValue({ pay_date: dayjs(), cash: 0, check: 0, discount: 0 })
    setQpOpen(true)
  }

  const handleQuickPay = async () => {
    try {
      const v = await qpForm.validateFields()
      setQpSaving(true)
      await poRecvApi.quickPay(activeRcvNo, {
        pay_date: v.pay_date.format('YYYY-MM-DD'),
        cash: v.cash || 0,
        check: v.check || 0,
        discount: v.discount || 0,
      })
      message.success('付款成功')
      setQpOpen(false)
      load(activeRcvNo)
    } catch (err) {
      if (err?.errorFields) return
      message.error(err.response?.data?.detail || '付款失敗')
    } finally {
      setQpSaving(false)
    }
  }

  const openHistory = async () => {
    const supNo = form.getFieldValue('sup_no')
    if (!supNo) return
    try {
      const res = await poRecvApi.history(supNo, isNew ? undefined : activeRcvNo)
      setHistData(res.data)
      setHistOpen(true)
      setHistLines([])
      setHistSelectedNo(res.data[0]?.rcv_no || null)
      if (res.data[0]) loadHistLines(res.data[0].rcv_no)
    } catch {
      message.error('查詢歷史失敗')
    }
  }

  const loadHistLines = async (rcvNoToLoad) => {
    setHistSelectedNo(rcvNoToLoad)
    setHistLinesLoading(true)
    try {
      const res = await poRecvApi.get(rcvNoToLoad)
      setHistLines(res.data.lines || [])
    } catch {
      message.error('查詢明細失敗')
    } finally {
      setHistLinesLoading(false)
    }
  }

  // ── 廠商歷史進貨紀錄視窗：比照主視窗的拖曳 + 縮放 ──
  useEffect(() => {
    if (histOpen) setHistSize(HIST_DEFAULT_SIZE)
  }, [histOpen])

  const recomputeHistHeights = useCallback(() => {
    setHistMasterScrollY(Math.max(80, (histMasterWrapRef.current?.offsetHeight || 0) - 40))
    setHistDetailScrollY(Math.max(80, (histDetailWrapRef.current?.offsetHeight || 0) - 40))
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [histSize.height, histSize.width])

  useLayoutEffect(() => { recomputeHistHeights() }, [recomputeHistHeights, histData.length, histLines.length])

  const onHistDragStart = (_e, uiData) => {
    const targetRect = histDraggleRef.current?.getBoundingClientRect()
    if (!targetRect) return
    setHistBounds({
      left: -targetRect.left + uiData.x,
      right: window.innerWidth - (targetRect.right - uiData.x),
      top: -targetRect.top + uiData.y,
      bottom: window.innerHeight - (targetRect.bottom - uiData.y),
    })
  }

  const histModalRender = (modalNode) => (
    <Draggable
      disabled={histDragDisabled}
      bounds={histBounds}
      nodeRef={histDraggleRef}
      onStart={onHistDragStart}
      handle=".porecv-hist-modal-title-bar"
    >
      <div ref={histDraggleRef}>{modalNode}</div>
    </Draggable>
  )

  const lineColumns = [
    { title: '序號', width: 50, render: (_, __, i) => i + 1 },
    { title: '產品編號', dataIndex: 'prd_no', width: 130 },
    { title: '料品名稱', dataIndex: 'prd_name', ellipsis: true },
    {
      title: '數量', dataIndex: 'rcd_qty', width: 100,
      render: (v, r) => editing ? (
        <InputNumber value={v} step={1} size="small" style={{ width: '100%' }}
          onChange={(val) => updateLine(r._key, { rcd_qty: val })} />
      ) : <span style={{ color: v < 0 ? '#cf1322' : undefined }}>{v}</span>,
    },
    {
      title: '單價', dataIndex: 'rcd_unit_price', width: 110,
      render: (v, r) => editing ? (
        <InputNumber value={v} step={1} size="small" style={{ width: '100%' }}
          onChange={(val) => updateLine(r._key, { rcd_unit_price: val })} />
      ) : Number(v).toLocaleString(),
    },
    {
      title: '小計', width: 100, align: 'right',
      render: (_, r) => (Number(r.rcd_qty || 0) * Number(r.rcd_unit_price || 0)).toLocaleString(),
    },
    { title: '現有數量', dataIndex: 'prd_onhand', width: 80, align: 'right' },
    ...(editing ? [{
      title: '', width: 40,
      render: (_, r) => <Button type="text" size="small" danger icon={<DeleteOutlined />} onClick={() => handleRemoveLine(r._key)} />,
    }] : []),
  ]

  const hasRecord = !isNew && !!header
  const isBooked = header?.rcv_status === 1

  return (
    <>
      <Modal
        open={open}
        onCancel={requestClose}
        footer={null}
        closable={false}
        mask={{ closable: false }}
        keyboard={false}
        width={size.width}
        modalRender={modalRender}
        styles={{ body: { padding: 0 }, container: { padding: 0 } }}
        destroyOnHidden
      >
        <Resizable
          width={size.width}
          height={size.height}
          minConstraints={[MIN_SIZE.width, MIN_SIZE.height]}
          maxConstraints={[window.innerWidth - 40, window.innerHeight - 40]}
          onResize={(_e, { size: s }) => setSize(s)}
        >
          <div style={{ width: size.width, height: size.height, display: 'flex', flexDirection: 'column', background: '#fff', borderRadius: 8, overflow: 'hidden', position: 'relative' }}>
          <Form form={form} layout="vertical" size="small" disabled={!editing} component={false}>
            {/* 標題列：拖曳把手 */}
            <div
              ref={titleRef}
              className="porecv-modal-title-bar"
              onMouseEnter={() => dragDisabled && setDragDisabled(false)}
              onMouseLeave={() => setDragDisabled(true)}
              style={{
                flex: '0 0 auto', cursor: 'move', padding: '8px 12px',
                background: '#1677ff', color: '#fff',
                display: 'flex', justifyContent: 'space-between', alignItems: 'center',
              }}
            >
              <Space>
                <span>進退貨作業</span>
                {header && <span>— {header.sup_name}</span>}
                {hasRecord && STATUS_TAG[header.rcv_status]}
              </Space>
              <CloseCircleOutlined onClick={requestClose} style={{ cursor: 'pointer', fontSize: 16 }} />
            </div>

            {/* 表頭：固定高度 */}
            <div ref={headerRef} style={{ flex: '0 0 auto', padding: '10px 12px 0' }}>
                <Row gutter={8}>
                  <Col span={8}>
                    <Form.Item name="sup_no" label="廠商編號/名稱" rules={[{ required: true, message: '必填' }]} style={ITEM_STYLE}>
                      <SearchSelect
                        fetcher={(q) => supplierApi.list({ q, page_size: 20 })}
                        valueField="sup_no"
                        labelFn={(s) => `${s.sup_no} ${s.sup_name}`}
                        initialLabel={header && `${header.sup_no} ${header.sup_name}`}
                        placeholder="搜尋廠商編號/名稱"
                      />
                    </Form.Item>
                  </Col>
                  <Col span={5}>
                    <Form.Item name="rcv_date" label="進貨日期" rules={[{ required: true, message: '必填' }]} style={ITEM_STYLE}>
                      <DatePicker style={{ width: '100%' }} />
                    </Form.Item>
                  </Col>
                  <Col span={5}>
                    <Form.Item label="憑證編號" style={ITEM_STYLE}>
                      <Input value={isNew ? '（存檔後自動產生）' : activeRcvNo} disabled />
                    </Form.Item>
                  </Col>
                  <Col span={6}>
                    <Form.Item name="rcv_inv_no" label="發票號碼" style={ITEM_STYLE}>
                      <Input maxLength={20} />
                    </Form.Item>
                  </Col>
                </Row>
              {editing && (
                <Row justify="end" style={{ marginBottom: 4 }}>
                  <Button type="dashed" size="small" icon={<PlusOutlined />} loading={addingLines} onClick={handleAddLines}>
                    新增品項（資料字典多選）
                  </Button>
                </Row>
              )}
            </div>

            {/* 表身：撐滿剩餘高度，卷軸在表格本身 */}
            <div style={{ flex: '1 1 auto', minHeight: 0, padding: '0 12px', overflow: 'hidden' }}>
              <Table
                rowKey="_key"
                size="small"
                columns={lineColumns}
                dataSource={lines}
                pagination={false}
                scroll={{ y: Math.max(80, bodyHeight - 40) }}
                loading={loading}
              />
            </div>

            {/* 表尾：固定高度 */}
            <div ref={footerRef} style={{ flex: '0 0 auto', padding: '8px 12px' }}>
                <Row gutter={8}>
                  <Col span={12}>
                    <Form.Item name="rcv_desc" label="備註" style={ITEM_STYLE}>
                      <TextArea rows={3} maxLength={200} />
                    </Form.Item>
                  </Col>
                  <Col span={6}>
                    <Form.Item label="未稅合計" style={ITEM_STYLE}>
                      <Input value={total.toLocaleString()} disabled style={{ textAlign: 'right' }} />
                    </Form.Item>
                    <Form.Item name="rcv_tax" label="稅額" style={ITEM_STYLE}>
                      <InputNumber min={0} style={{ width: '100%' }} />
                    </Form.Item>
                  </Col>
                  <Col span={6}>
                    <Form.Item label="&nbsp;" style={ITEM_STYLE}>
                      <Input value=" " disabled style={{ border: 'none', background: 'transparent' }} />
                    </Form.Item>
                    <Form.Item label="含稅合計" style={ITEM_STYLE}>
                      <Input value={(total + (Number(currentTax) || 0)).toLocaleString()} disabled style={{ textAlign: 'right' }} />
                    </Form.Item>
                  </Col>
                </Row>
            </div>
          </Form>

            {/* 工具列：動作按鈕不受表單 disabled 影響 */}
            <div style={{ flex: '0 0 auto', padding: '0 12px 8px' }}>
              <Row justify="space-between" align="middle">
                <Col>
                  <Space wrap>
                    {!editing && (
                      <>
                        <Button size="small" icon={<EditOutlined />} disabled={!hasRecord || isBooked} onClick={handleEdit}>修改</Button>
                        <Button size="small" danger icon={<DeleteOutlined />} disabled={!hasRecord || isBooked} onClick={handleDelete}>刪除</Button>
                        {hasRecord && !isBooked && (
                          <Button size="small" type="primary" icon={<CheckCircleOutlined />} onClick={handleBook}>確認</Button>
                        )}
                        {hasRecord && isBooked && (
                          <Button size="small" icon={<UndoOutlined />} onClick={handleUnbook}>取消確認</Button>
                        )}
                        {hasRecord && isBooked && header.rcv_not_clean > 0 && (
                          <Button size="small" icon={<DollarOutlined />} onClick={openQuickPay}>快速付款</Button>
                        )}
                      </>
                    )}
                    {editing && (
                      <>
                        <Button size="small" type="primary" icon={<SaveOutlined />} loading={saving} onClick={handleSave}>存檔</Button>
                        <Button size="small" icon={<CloseOutlined />} onClick={handleAbort}>放棄</Button>
                      </>
                    )}
                    <Button size="small" icon={<HistoryOutlined />} onClick={openHistory} disabled={!currentSupNo}>歷史查詢</Button>
                  </Space>
                </Col>
                <Col>
                  {hasRecord && (
                    <Text type="secondary">
                      未付款：<Text strong type={header.rcv_not_clean > 0 ? 'danger' : 'success'}>{Number(header.rcv_not_clean).toLocaleString()}</Text>
                    </Text>
                  )}
                </Col>
              </Row>
            </div>
          </div>
        </Resizable>
      </Modal>

      <Modal
        title="快速付款"
        open={qpOpen}
        onOk={handleQuickPay}
        onCancel={() => setQpOpen(false)}
        confirmLoading={qpSaving}
        okText="確定"
        cancelText="取消"
        destroyOnHidden
        zIndex={1050}
      >
        <Form form={qpForm} layout="vertical" size="small">
          <Text type="secondary">未清帳款：{header ? Number(header.rcv_not_clean).toLocaleString() : 0}</Text>
          <Form.Item name="pay_date" label="付款日期" rules={[{ required: true, message: '必填' }]} style={{ marginTop: 12 }}>
            <DatePicker style={{ width: '100%' }} />
          </Form.Item>
          <Row gutter={12}>
            <Col span={8}>
              <Form.Item name="cash" label="現金">
                <InputNumber min={0} style={{ width: '100%' }} />
              </Form.Item>
            </Col>
            <Col span={8}>
              <Form.Item name="check" label="票據">
                <InputNumber min={0} style={{ width: '100%' }} />
              </Form.Item>
            </Col>
            <Col span={8}>
              <Form.Item name="discount" label="折讓">
                <InputNumber min={0} style={{ width: '100%' }} />
              </Form.Item>
            </Col>
          </Row>
        </Form>
      </Modal>

      <Modal
        open={histOpen}
        onCancel={() => setHistOpen(false)}
        footer={null}
        closable={false}
        mask={{ closable: false }}
        width={histSize.width}
        modalRender={histModalRender}
        styles={{ body: { padding: 0 }, container: { padding: 0 } }}
        destroyOnHidden
        zIndex={1050}
      >
        <style>{HIST_DARK_CSS}</style>
        <Resizable
          width={histSize.width}
          height={histSize.height}
          minConstraints={[HIST_MIN_SIZE.width, HIST_MIN_SIZE.height]}
          maxConstraints={[window.innerWidth - 40, window.innerHeight - 40]}
          onResize={(_e, { size: s }) => setHistSize(s)}
        >
          <div
            className="porecv-hist-dark"
            style={{
              width: histSize.width, height: histSize.height, display: 'flex', flexDirection: 'column',
              background: '#0b3d2e', color: '#fff', borderRadius: 8, overflow: 'hidden', position: 'relative',
            }}
          >
            <div
              className="porecv-hist-modal-title-bar"
              onMouseEnter={() => histDragDisabled && setHistDragDisabled(false)}
              onMouseLeave={() => setHistDragDisabled(true)}
              style={{
                flex: '0 0 auto', cursor: 'move', padding: '8px 12px',
                background: '#1677ff', color: '#fff',
                display: 'flex', justifyContent: 'space-between', alignItems: 'center',
              }}
            >
              <span>廠商歷史進貨紀錄</span>
              <CloseCircleOutlined onClick={() => setHistOpen(false)} style={{ cursor: 'pointer', fontSize: 16 }} />
            </div>

            <div style={{ flex: '1 1 0%', minHeight: 0, padding: '8px 12px 4px', display: 'flex', flexDirection: 'column' }}>
              <Text strong style={{ color: '#fff', marginBottom: 4 }}>進貨單主檔</Text>
              <div ref={histMasterWrapRef} style={{ flex: '1 1 auto', minHeight: 0 }}>
                <Table
                  rowKey="rcv_no"
                  size="small"
                  dataSource={histData}
                  pagination={false}
                  scroll={{ y: histMasterScrollY }}
                  rowClassName={(record) => record.rcv_no === histSelectedNo ? 'porecv-hist-row-selected' : ''}
                  onRow={(record) => ({
                    onClick: () => loadHistLines(record.rcv_no),
                    style: { cursor: 'pointer' },
                  })}
                  columns={[
                    { title: '進貨單號', dataIndex: 'rcv_no', width: 120 },
                    { title: '日期', dataIndex: 'rcv_date', width: 100, render: (v) => dayjs(v).format('YYYY-MM-DD') },
                    { title: '未稅合計', dataIndex: 'rcv_total', width: 90, align: 'right', render: (v) => Number(v).toLocaleString() },
                    { title: '稅額', dataIndex: 'rcv_tax', width: 70, align: 'right', render: (v) => Number(v).toLocaleString() },
                    {
                      title: '含稅合計', width: 90, align: 'right',
                      render: (_, r) => (Number(r.rcv_total) + Number(r.rcv_tax)).toLocaleString(),
                    },
                    { title: '未付款', dataIndex: 'rcv_not_clean', width: 90, align: 'right', render: (v) => Number(v).toLocaleString() },
                    { title: '發票號碼', dataIndex: 'rcv_inv_no', width: 100 },
                    { title: '狀態', dataIndex: 'rcv_status', width: 80, render: (v) => STATUS_TAG[v] || v },
                    { title: '備註', dataIndex: 'rcv_desc', ellipsis: true },
                  ]}
                />
              </div>
            </div>

            <div style={{ flex: '1 1 0%', minHeight: 0, padding: '4px 12px 8px', display: 'flex', flexDirection: 'column' }}>
              <Text strong style={{ color: '#fff', marginBottom: 4 }}>進貨單明細{histSelectedNo ? `（${histSelectedNo}）` : ''}</Text>
              <div ref={histDetailWrapRef} style={{ flex: '1 1 auto', minHeight: 0 }}>
                <Table
                  rowKey="rcd_seqno"
                  size="small"
                  dataSource={histLines}
                  loading={histLinesLoading}
                  pagination={false}
                  scroll={{ y: histDetailScrollY }}
                  columns={[
                    { title: '序號', dataIndex: 'rcd_seqno', width: 60 },
                    { title: '產品編號', dataIndex: 'prd_no', width: 140 },
                    { title: '產品名稱', dataIndex: 'prd_name', ellipsis: true },
                    { title: '單價', dataIndex: 'rcd_unit_price', width: 90, align: 'right', render: (v) => Number(v).toLocaleString() },
                    { title: '數量', dataIndex: 'rcd_qty', width: 70, align: 'right' },
                    {
                      title: '小計', width: 90, align: 'right',
                      render: (_, r) => (Number(r.rcd_qty) * Number(r.rcd_unit_price)).toLocaleString(),
                    },
                  ]}
                />
              </div>
            </div>

            <div style={{ flex: '0 0 auto', padding: '8px 12px', textAlign: 'right', borderTop: '1px solid #1f5c46' }}>
              <Button onClick={() => setHistOpen(false)}>關閉</Button>
            </div>
          </div>
        </Resizable>
      </Modal>
    </>
  )
}

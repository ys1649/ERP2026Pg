import { useState, useEffect, useCallback } from 'react'
import {
  Modal, Form, Input, InputNumber, DatePicker, Button, Space,
  Table, message, Typography, Row, Col,
} from 'antd'
import { SaveOutlined, CloseOutlined, DeleteOutlined, ThunderboltOutlined } from '@ant-design/icons'
import dayjs from 'dayjs'
import { apPayApi } from '../api/apPay'
import { supplierApi } from '../api/suppliers'
import { SearchSelect } from './SearchSelect'

const { Text } = Typography
const { TextArea } = Input

export default function ApPayFormModal({ open, payNo, onClose }) {
  const [activePayNo, setActivePayNo] = useState(payNo)
  const isNew = activePayNo === 'new'
  const [form] = Form.useForm()
  const [mode, setMode] = useState('view')
  const [header, setHeader] = useState(null)
  const [lines, setLines] = useState([])
  const [loading, setLoading] = useState(false)
  const [candidatesLoading, setCandidatesLoading] = useState(false)
  const [saving, setSaving] = useState(false)

  const editing = mode === 'create'

  const load = useCallback(async (targetPayNo) => {
    if (targetPayNo === 'new') {
      setHeader(null)
      setLines([])
      form.resetFields()
      form.setFieldsValue({ pay_date: dayjs(), pay_cash: 0, pay_check: 0, pay_from_advance: 0, pay_to_advance: 0 })
      setMode('create')
      return
    }
    setLoading(true)
    try {
      const res = await apPayApi.get(targetPayNo)
      setHeader(res.data)
      setLines(res.data.lines.map((l, i) => ({ ...l, _key: i })))
      form.setFieldsValue({ ...res.data, pay_date: dayjs(res.data.pay_date) })
      setMode('view')
    } catch {
      message.error('載入付款單失敗')
      onClose()
    } finally {
      setLoading(false)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [form])

  useEffect(() => {
    if (!open) return
    setActivePayNo(payNo)
    load(payNo)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, payNo, load])

  // 比照 InsertClientDT：新增狀態下廠商或日期一變動，整批重建候選進貨單清單（手動輸入的分配金額會被清空，比照舊系統行為）
  const rebuildCandidates = async (supNo, payDateDayjs) => {
    if (!supNo || !payDateDayjs) {
      setLines([])
      return
    }
    setCandidatesLoading(true)
    try {
      const res = await apPayApi.candidates(supNo, payDateDayjs.format('YYYY-MM-DD'))
      setLines(res.data.map((row, i) => ({ ...row, _key: i, pad_amount: 0, pad_discount: 0 })))
    } catch {
      message.error('查詢未清進貨單失敗')
    } finally {
      setCandidatesLoading(false)
    }
  }

  const handleSupNoChange = (val) => {
    form.setFieldValue('sup_no', val)
    if (editing) rebuildCandidates(val, form.getFieldValue('pay_date'))
  }

  const handleDateChange = (val) => {
    form.setFieldValue('pay_date', val)
    if (editing) rebuildCandidates(form.getFieldValue('sup_no'), val)
  }

  const updateLine = (key, patch) => {
    setLines((prev) => prev.map((l) => (l._key === key ? { ...l, ...patch } : l)))
  }

  const cash = Form.useWatch('pay_cash', form) ?? 0
  const check = Form.useWatch('pay_check', form) ?? 0
  const fromAdvance = Form.useWatch('pay_from_advance', form) ?? 0
  const toAdvance = Form.useWatch('pay_to_advance', form) ?? 0
  const revSum = (Number(cash) || 0) + (Number(check) || 0) + (Number(fromAdvance) || 0) - (Number(toAdvance) || 0)
  const amountSum = lines.reduce((s, l) => s + (Number(l.pad_amount) || 0), 0)
  const balance = revSum - amountSum

  const handleAutoFillin = () => {
    let remaining = revSum
    const next = lines.map((l) => {
      const alloc = Math.min(remaining, Number(l.rcv_not_clean) || 0)
      remaining -= alloc
      return { ...l, pad_amount: alloc, pad_discount: 0 }
    })
    setLines(next)
    if (remaining > 0) message.warning('付款金額太多 !')
  }

  const handleAbort = () => {
    if (isNew) { onClose(); return }
    load(activePayNo)
  }

  const requestClose = () => {
    if (editing) {
      message.warning('正在新增中，請先存檔或放棄')
      return
    }
    onClose()
  }

  const handleSave = async () => {
    try {
      const values = await form.validateFields()
      const payload = {
        sup_no: values.sup_no,
        pay_date: values.pay_date.format('YYYY-MM-DD'),
        pay_cash: values.pay_cash || 0,
        pay_check: values.pay_check || 0,
        pay_from_advance: values.pay_from_advance || 0,
        pay_to_advance: values.pay_to_advance || 0,
        pay_desc: values.pay_desc || null,
        lines: lines.map((l) => ({
          rcv_no: l.rcv_no,
          pad_amount: Number(l.pad_amount) || 0,
          pad_discount: Number(l.pad_discount) || 0,
        })),
      }
      setSaving(true)
      const res = await apPayApi.create(payload)
      message.success('付款成功')
      setActivePayNo(res.data.pay_no)
      await load(res.data.pay_no)
    } catch (err) {
      if (err?.errorFields) return
      message.error(err.response?.data?.detail || '儲存失敗')
    } finally {
      setSaving(false)
    }
  }

  const handleDelete = () => {
    Modal.confirm({
      title: `確定刪除付款單「${activePayNo}」？`,
      okText: '刪除',
      okButtonProps: { danger: true },
      cancelText: '取消',
      onOk: async () => {
        try {
          await apPayApi.remove(activePayNo)
          message.success('刪除成功')
          onClose()
        } catch (err) {
          message.error(err.response?.data?.detail || '刪除失敗')
        }
      },
    })
  }

  const lineColumns = [
    { title: '進貨單號', dataIndex: 'rcv_no', width: 120 },
    { title: '進貨日期', dataIndex: 'rcv_date', width: 100, render: (v) => dayjs(v).format('YYYY-MM-DD') },
    { title: '發票號碼', dataIndex: 'rcv_inv_no', width: 100 },
    { title: '進貨金額', dataIndex: 'rcv_amount', width: 100, align: 'right', render: (v) => Number(v).toLocaleString() },
    { title: '未清餘額', dataIndex: 'rcv_not_clean', width: 100, align: 'right', render: (v) => Number(v).toLocaleString() },
    {
      title: '沖帳金額', dataIndex: 'pad_amount', width: 120,
      render: (v, r) => editing ? (
        <InputNumber size="small" style={{ width: '100%' }} value={v}
          onChange={(val) => updateLine(r._key, { pad_amount: val || 0 })} />
      ) : Number(v).toLocaleString(),
    },
    {
      title: '折讓', dataIndex: 'pad_discount', width: 100,
      render: (v, r) => editing ? (
        <InputNumber size="small" style={{ width: '100%' }} value={v}
          onChange={(val) => updateLine(r._key, { pad_discount: val || 0 })} />
      ) : Number(v).toLocaleString(),
    },
  ]

  const hasRecord = !isNew && !!header

  return (
    <Modal
      open={open}
      onCancel={requestClose}
      footer={null}
      width={920}
      title={header ? `進貨付款作業 — ${header.pay_no}` : '進貨付款作業 — 新增'}
      destroyOnHidden
      maskClosable={false}
    >
      <Form form={form} layout="vertical" size="small" disabled={!editing}>
        <Row gutter={8}>
          <Col span={8}>
            <Form.Item name="sup_no" label="廠商編號/名稱" rules={[{ required: true, message: '必填' }]}>
              <SearchSelect
                fetcher={(q) => supplierApi.list({ q, page_size: 20 })}
                valueField="sup_no"
                labelFn={(s) => `${s.sup_no} ${s.sup_name}`}
                initialLabel={header && `${header.sup_no} ${header.sup_name}`}
                onChange={handleSupNoChange}
                placeholder="搜尋廠商編號/名稱"
              />
            </Form.Item>
          </Col>
          <Col span={5}>
            <Form.Item name="pay_date" label="付款日期" rules={[{ required: true, message: '必填' }]}>
              <DatePicker style={{ width: '100%' }} onChange={handleDateChange} />
            </Form.Item>
          </Col>
          <Col span={5}>
            <Form.Item label="付款單號">
              <Input value={isNew ? '（存檔後自動產生）' : activePayNo} disabled />
            </Form.Item>
          </Col>
        </Row>
        <Row gutter={8}>
          <Col span={4}>
            <Form.Item name="pay_cash" label="現金">
              <InputNumber style={{ width: '100%' }} />
            </Form.Item>
          </Col>
          <Col span={4}>
            <Form.Item name="pay_check" label="票據">
              <InputNumber style={{ width: '100%' }} />
            </Form.Item>
          </Col>
          <Col span={4}>
            <Form.Item name="pay_from_advance" label="動用預付">
              <InputNumber style={{ width: '100%' }} />
            </Form.Item>
          </Col>
          <Col span={4}>
            <Form.Item name="pay_to_advance" label="轉入預付">
              <InputNumber style={{ width: '100%' }} />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item name="pay_desc" label="備註">
              <TextArea rows={1} maxLength={200} />
            </Form.Item>
          </Col>
        </Row>
      </Form>

      {editing && (
        <Row justify="end" style={{ marginBottom: 8 }}>
          <Button size="small" icon={<ThunderboltOutlined />} onClick={handleAutoFillin} disabled={lines.length === 0}>
            自動分配
          </Button>
        </Row>
      )}

      <Table
        rowKey="_key"
        size="small"
        columns={lineColumns}
        dataSource={lines}
        pagination={false}
        loading={loading || candidatesLoading}
        scroll={{ y: 280 }}
        locale={{ emptyText: editing ? '請先選擇廠商與付款日期' : '無資料' }}
      />

      <Row justify="end" style={{ marginTop: 8 }}>
        <Space size="large">
          <Text>付款合計：{revSum.toLocaleString()}</Text>
          <Text>分配合計：{amountSum.toLocaleString()}</Text>
          <Text strong type={balance === 0 ? 'success' : 'danger'}>差額：{balance.toLocaleString()}</Text>
        </Space>
      </Row>

      <Row justify="space-between" align="middle" style={{ marginTop: 12 }}>
        <Col>
          <Space wrap>
            {!editing && (
              <Button size="small" danger icon={<DeleteOutlined />} disabled={!hasRecord} onClick={handleDelete}>刪除</Button>
            )}
            {editing && (
              <>
                <Button size="small" type="primary" icon={<SaveOutlined />} loading={saving} onClick={handleSave}>存檔</Button>
                <Button size="small" icon={<CloseOutlined />} onClick={handleAbort}>放棄</Button>
              </>
            )}
          </Space>
        </Col>
      </Row>
    </Modal>
  )
}

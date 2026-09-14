import { useState, useEffect, useCallback } from 'react'
import {
  Modal, Form, Input, InputNumber, DatePicker, Button, Space,
  Table, message, Typography, Row, Col,
} from 'antd'
import { SaveOutlined, CloseOutlined, DeleteOutlined, ThunderboltOutlined } from '@ant-design/icons'
import dayjs from 'dayjs'
import { arRecvApi } from '../api/arRecv'
import { customerApi } from '../api/customers'
import { SearchSelect } from './SearchSelect'

const { Text } = Typography
const { TextArea } = Input

export default function ArRecvFormModal({ open, arrNo, onClose }) {
  const [activeArrNo, setActiveArrNo] = useState(arrNo)
  const isNew = activeArrNo === 'new'
  const [form] = Form.useForm()
  const [mode, setMode] = useState('view')
  const [header, setHeader] = useState(null)
  const [lines, setLines] = useState([])
  const [loading, setLoading] = useState(false)
  const [candidatesLoading, setCandidatesLoading] = useState(false)
  const [saving, setSaving] = useState(false)

  const editing = mode === 'create'

  const load = useCallback(async (targetArrNo) => {
    if (targetArrNo === 'new') {
      setHeader(null)
      setLines([])
      form.resetFields()
      form.setFieldsValue({ arr_date: dayjs(), arr_cash: 0, arr_check: 0, arr_from_advance: 0, arr_to_advance: 0 })
      setMode('create')
      return
    }
    setLoading(true)
    try {
      const res = await arRecvApi.get(targetArrNo)
      setHeader(res.data)
      setLines(res.data.lines.map((l, i) => ({ ...l, _key: i })))
      form.setFieldsValue({ ...res.data, arr_date: dayjs(res.data.arr_date) })
      setMode('view')
    } catch {
      message.error('載入收款單失敗')
      onClose()
    } finally {
      setLoading(false)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [form])

  useEffect(() => {
    if (!open) return
    setActiveArrNo(arrNo)
    load(arrNo)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, arrNo, load])

  // 比照 InsertClientDT：新增狀態下客戶或日期一變動，整批重建候選出貨單清單（手動輸入的分配金額會被清空，比照舊系統行為）
  const rebuildCandidates = async (cumNo, arrDateDayjs) => {
    if (!cumNo || !arrDateDayjs) {
      setLines([])
      return
    }
    setCandidatesLoading(true)
    try {
      const res = await arRecvApi.candidates(cumNo, arrDateDayjs.format('YYYY-MM-DD'))
      setLines(res.data.map((row, i) => ({ ...row, _key: i, ard_amount: 0, ard_discount: 0 })))
    } catch {
      message.error('查詢未清出貨單失敗')
    } finally {
      setCandidatesLoading(false)
    }
  }

  const handleCumNoChange = (val) => {
    form.setFieldValue('cum_no', val)
    if (editing) rebuildCandidates(val, form.getFieldValue('arr_date'))
  }

  const handleDateChange = (val) => {
    form.setFieldValue('arr_date', val)
    if (editing) rebuildCandidates(form.getFieldValue('cum_no'), val)
  }

  const updateLine = (key, patch) => {
    setLines((prev) => prev.map((l) => (l._key === key ? { ...l, ...patch } : l)))
  }

  const cash = Form.useWatch('arr_cash', form) ?? 0
  const check = Form.useWatch('arr_check', form) ?? 0
  const fromAdvance = Form.useWatch('arr_from_advance', form) ?? 0
  const toAdvance = Form.useWatch('arr_to_advance', form) ?? 0
  const revSum = (Number(cash) || 0) + (Number(check) || 0) + (Number(fromAdvance) || 0) - (Number(toAdvance) || 0)
  const amountSum = lines.reduce((s, l) => s + (Number(l.ard_amount) || 0), 0)
  const balance = revSum - amountSum

  const handleAutoFillin = () => {
    let remaining = revSum
    const next = lines.map((l) => {
      const alloc = Math.min(remaining, Number(l.smt_not_clean) || 0)
      remaining -= alloc
      return { ...l, ard_amount: alloc, ard_discount: 0 }
    })
    setLines(next)
    if (remaining > 0) message.warning('款項金額太多 !')
  }

  const handleAbort = () => {
    if (isNew) { onClose(); return }
    load(activeArrNo)
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
        cum_no: values.cum_no,
        arr_date: values.arr_date.format('YYYY-MM-DD'),
        arr_cash: values.arr_cash || 0,
        arr_check: values.arr_check || 0,
        arr_from_advance: values.arr_from_advance || 0,
        arr_to_advance: values.arr_to_advance || 0,
        arr_desc: values.arr_desc || null,
        lines: lines.map((l) => ({
          smt_no: l.smt_no,
          ard_amount: Number(l.ard_amount) || 0,
          ard_discount: Number(l.ard_discount) || 0,
        })),
      }
      setSaving(true)
      const res = await arRecvApi.create(payload)
      message.success('收款成功')
      setActiveArrNo(res.data.arr_no)
      await load(res.data.arr_no)
    } catch (err) {
      if (err?.errorFields) return
      message.error(err.response?.data?.detail || '儲存失敗')
    } finally {
      setSaving(false)
    }
  }

  const handleDelete = () => {
    Modal.confirm({
      title: `確定刪除收款單「${activeArrNo}」？`,
      okText: '刪除',
      okButtonProps: { danger: true },
      cancelText: '取消',
      onOk: async () => {
        try {
          await arRecvApi.remove(activeArrNo)
          message.success('刪除成功')
          onClose()
        } catch (err) {
          message.error(err.response?.data?.detail || '刪除失敗')
        }
      },
    })
  }

  const lineColumns = [
    { title: '出貨單號', dataIndex: 'smt_no', width: 120 },
    { title: '出貨日期', dataIndex: 'smt_date', width: 100, render: (v) => dayjs(v).format('YYYY-MM-DD') },
    { title: '發票號碼', dataIndex: 'smt_inv_no', width: 100 },
    { title: '出貨金額', dataIndex: 'smt_amount', width: 100, align: 'right', render: (v) => Number(v).toLocaleString() },
    { title: '未清餘額', dataIndex: 'smt_not_clean', width: 100, align: 'right', render: (v) => Number(v).toLocaleString() },
    {
      title: '沖帳金額', dataIndex: 'ard_amount', width: 120,
      render: (v, r) => editing ? (
        <InputNumber size="small" style={{ width: '100%' }} value={v}
          onChange={(val) => updateLine(r._key, { ard_amount: val || 0 })} />
      ) : Number(v).toLocaleString(),
    },
    {
      title: '折讓', dataIndex: 'ard_discount', width: 100,
      render: (v, r) => editing ? (
        <InputNumber size="small" style={{ width: '100%' }} value={v}
          onChange={(val) => updateLine(r._key, { ard_discount: val || 0 })} />
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
      title={header ? `應收帳款收款作業 — ${header.arr_no}` : '應收帳款收款作業 — 新增'}
      destroyOnHidden
      maskClosable={false}
    >
      <Form form={form} layout="vertical" size="small" disabled={!editing}>
        <Row gutter={8}>
          <Col span={8}>
            <Form.Item name="cum_no" label="客戶編號/名稱" rules={[{ required: true, message: '必填' }]}>
              <SearchSelect
                fetcher={(q) => customerApi.list({ q, page_size: 20 })}
                valueField="cum_no"
                labelFn={(c) => `${c.cum_no} ${c.cum_name}`}
                initialLabel={header && `${header.cum_no} ${header.cum_name}`}
                onChange={handleCumNoChange}
                placeholder="搜尋客戶編號/名稱"
              />
            </Form.Item>
          </Col>
          <Col span={5}>
            <Form.Item name="arr_date" label="收款日期" rules={[{ required: true, message: '必填' }]}>
              <DatePicker style={{ width: '100%' }} onChange={handleDateChange} />
            </Form.Item>
          </Col>
          <Col span={5}>
            <Form.Item label="收款單號">
              <Input value={isNew ? '（存檔後自動產生）' : activeArrNo} disabled />
            </Form.Item>
          </Col>
        </Row>
        <Row gutter={8}>
          <Col span={4}>
            <Form.Item name="arr_cash" label="現金">
              <InputNumber style={{ width: '100%' }} />
            </Form.Item>
          </Col>
          <Col span={4}>
            <Form.Item name="arr_check" label="票據">
              <InputNumber style={{ width: '100%' }} />
            </Form.Item>
          </Col>
          <Col span={4}>
            <Form.Item name="arr_from_advance" label="動用預收">
              <InputNumber style={{ width: '100%' }} />
            </Form.Item>
          </Col>
          <Col span={4}>
            <Form.Item name="arr_to_advance" label="轉入預收">
              <InputNumber style={{ width: '100%' }} />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item name="arr_desc" label="備註">
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
        locale={{ emptyText: editing ? '請先選擇客戶與收款日期' : '無資料' }}
      />

      <Row justify="end" style={{ marginTop: 8 }}>
        <Space size="large">
          <Text>收款合計：{revSum.toLocaleString()}</Text>
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

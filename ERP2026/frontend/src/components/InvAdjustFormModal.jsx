import { useState, useEffect, useCallback } from 'react'
import {
  Modal, Form, Input, InputNumber, DatePicker, Button, Space,
  Table, message, Tag, Row, Col,
} from 'antd'
import {
  SaveOutlined, CloseOutlined, EditOutlined, DeleteOutlined,
  CheckCircleOutlined, UndoOutlined, PlusOutlined,
} from '@ant-design/icons'
import dayjs from 'dayjs'
import { invAdjustApi } from '../api/invAdjust'
import { DDLookup } from '../lib/ddLookup'

const { TextArea } = Input

const STATUS_TAG = { 0: <Tag color="orange">未確認</Tag>, 1: <Tag color="green">已確認</Tag> }

export default function InvAdjustFormModal({ open, adjNo, onClose }) {
  const [activeAdjNo, setActiveAdjNo] = useState(adjNo)
  const isNew = activeAdjNo === 'new'
  const [form] = Form.useForm()
  const [mode, setMode] = useState('view')
  const [header, setHeader] = useState(null)
  const [lines, setLines] = useState([])
  const [loading, setLoading] = useState(false)
  const [saving, setSaving] = useState(false)
  const [addingLines, setAddingLines] = useState(false)
  const [seq, setSeq] = useState(0)

  const editing = mode === 'edit' || mode === 'create'

  const load = useCallback(async (targetAdjNo) => {
    if (targetAdjNo === 'new') {
      setHeader(null)
      setLines([])
      setSeq(0)
      form.resetFields()
      form.setFieldsValue({ adj_date: dayjs() })
      setMode('create')
      return
    }
    setLoading(true)
    try {
      const res = await invAdjustApi.get(targetAdjNo)
      setHeader(res.data)
      setLines(res.data.lines.map((l, i) => ({ ...l, _key: i })))
      setSeq(res.data.lines.length)
      form.setFieldsValue({ ...res.data, adj_date: dayjs(res.data.adj_date) })
      setMode('view')
    } catch {
      message.error('載入調整單失敗')
      onClose()
    } finally {
      setLoading(false)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [form])

  useEffect(() => {
    if (!open) return
    setActiveAdjNo(adjNo)
    load(adjNo)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, adjNo, load])

  const updateLine = (key, patch) => {
    setLines((prev) => prev.map((l) => (l._key === key ? { ...l, ...patch } : l)))
  }

  const handleRemoveLine = (key) => setLines((prev) => prev.filter((l) => l._key !== key))

  const handleAddLines = async () => {
    const result = await DDLookup.getDDLookup('TBL_PRODUCT')
    if (!result || result.rows.length === 0) return
    setAddingLines(true)
    try {
      const startKey = seq
      const enriched = await Promise.all(result.rows.map(async (row, i) => {
        const costRes = await invAdjustApi.currentCost(row.prd_no).catch(() => ({ data: { price: 0 } }))
        return {
          _key: startKey + i,
          prd_no: row.prd_no,
          prd_name: row.prd_name,
          prd_onhand: row.prd_onhand,
          add_cost: costRes.data.price,
          add_qty: 1,
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
    load(activeAdjNo)
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
      for (const l of lines) {
        if (!Number(l.add_qty)) { message.error('此數量不可為0'); return }
      }
      const payload = {
        adj_date: values.adj_date.format('YYYY-MM-DD'),
        adj_desc: values.adj_desc || null,
        lines: lines.map((l) => ({
          prd_no: l.prd_no,
          add_qty: Number(l.add_qty) || 0,
          add_cost: Number(l.add_cost) || 0,
        })),
      }
      setSaving(true)
      if (isNew) {
        const res = await invAdjustApi.create(payload)
        message.success('新增成功')
        setActiveAdjNo(res.data.adj_no)
        await load(res.data.adj_no)
      } else {
        await invAdjustApi.update(activeAdjNo, payload)
        message.success('更新成功')
        await load(activeAdjNo)
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
      title: `確定刪除調整單「${activeAdjNo}」？`,
      okText: '刪除',
      okButtonProps: { danger: true },
      cancelText: '取消',
      onOk: async () => {
        try {
          await invAdjustApi.remove(activeAdjNo)
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
      await invAdjustApi.book(activeAdjNo)
      message.success('確認成功')
      load(activeAdjNo)
    } catch (err) {
      message.error(err.response?.data?.detail || '確認失敗')
    }
  }

  const handleUnbook = async () => {
    try {
      await invAdjustApi.unbook(activeAdjNo)
      message.success('取消確認成功')
      load(activeAdjNo)
    } catch (err) {
      message.error(err.response?.data?.detail || '取消確認失敗')
    }
  }

  const lineColumns = [
    { title: '序號', width: 50, render: (_, __, i) => i + 1 },
    { title: '產品編號', dataIndex: 'prd_no', width: 130 },
    { title: '料品名稱', dataIndex: 'prd_name', ellipsis: true },
    { title: '現有數量', dataIndex: 'prd_onhand', width: 90, align: 'right' },
    {
      title: '調整數量', dataIndex: 'add_qty', width: 120,
      render: (v, r) => editing ? (
        <InputNumber value={v} step={1} size="small" style={{ width: '100%' }}
          onChange={(val) => updateLine(r._key, { add_qty: val })} />
      ) : <span style={{ color: v < 0 ? '#cf1322' : undefined }}>{v}</span>,
    },
    {
      title: '成本', dataIndex: 'add_cost', width: 110,
      render: (v, r) => editing ? (
        <InputNumber value={v} step={1} size="small" style={{ width: '100%' }}
          onChange={(val) => updateLine(r._key, { add_cost: val })} />
      ) : Number(v).toLocaleString(),
    },
    {
      title: '小計', width: 100, align: 'right',
      render: (_, r) => (Number(r.add_qty || 0) * Number(r.add_cost || 0)).toLocaleString(),
    },
    ...(editing ? [{
      title: '', width: 40,
      render: (_, r) => <Button type="text" size="small" danger icon={<DeleteOutlined />} onClick={() => handleRemoveLine(r._key)} />,
    }] : []),
  ]

  const hasRecord = !isNew && !!header
  const isBooked = header?.adj_status === 1

  return (
    <Modal
      open={open}
      onCancel={requestClose}
      footer={null}
      width={860}
      title={header ? `庫房調整單 — ${header.adj_no}` : '庫房調整單 — 新增'}
      destroyOnHidden
      maskClosable={false}
    >
      <Form form={form} layout="vertical" size="small" disabled={!editing}>
        <Row gutter={8}>
          <Col span={5}>
            <Form.Item name="adj_date" label="調整日期" rules={[{ required: true, message: '必填' }]}>
              <DatePicker style={{ width: '100%' }} />
            </Form.Item>
          </Col>
          <Col span={5}>
            <Form.Item label="調整單號">
              <Input value={isNew ? '（存檔後自動產生）' : activeAdjNo} disabled />
              {hasRecord && <span style={{ marginLeft: 8 }}>{STATUS_TAG[header.adj_status]}</span>}
            </Form.Item>
          </Col>
          <Col span={14}>
            <Form.Item name="adj_desc" label="備註">
              <TextArea rows={1} maxLength={200} />
            </Form.Item>
          </Col>
        </Row>
      </Form>

      {editing && (
        <Row justify="end" style={{ marginBottom: 8 }}>
          <Button type="dashed" size="small" icon={<PlusOutlined />} loading={addingLines} onClick={handleAddLines}>
            新增品項（資料字典多選）
          </Button>
        </Row>
      )}

      <Table
        rowKey="_key"
        size="small"
        columns={lineColumns}
        dataSource={lines}
        pagination={false}
        loading={loading}
        scroll={{ y: 320 }}
      />

      <Row justify="space-between" align="middle" style={{ marginTop: 12 }}>
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
              </>
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

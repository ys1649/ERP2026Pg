import { useState, useEffect, useCallback } from 'react'
import {
  Modal, Form, Input, InputNumber, DatePicker, Button, Space,
  Table, message, Typography, Row, Col,
} from 'antd'
import {
  SaveOutlined, CloseOutlined, EditOutlined, DeleteOutlined, PlusOutlined,
} from '@ant-design/icons'
import dayjs from 'dayjs'
import { acntJournalApi } from '../api/acntJournal'
import { acntAccountApi } from '../api/acntAccounts'
import { SearchSelect } from './SearchSelect'

const { Text } = Typography

export default function JournalFormModal({ open, jnlNo, onClose }) {
  const [activeJnlNo, setActiveJnlNo] = useState(jnlNo)
  const isNew = activeJnlNo === 'new'
  const [form] = Form.useForm()
  const [mode, setMode] = useState('view')
  const [header, setHeader] = useState(null)
  const [lines, setLines] = useState([])
  const [loading, setLoading] = useState(false)
  const [saving, setSaving] = useState(false)
  const [seq, setSeq] = useState(0)

  const load = useCallback(async (targetJnlNo) => {
    if (targetJnlNo === 'new') {
      setHeader(null)
      setLines([])
      setSeq(0)
      form.resetFields()
      form.setFieldsValue({ jnl_date: dayjs() })
      setMode('create')
      return
    }
    setLoading(true)
    try {
      const res = await acntJournalApi.get(targetJnlNo)
      setHeader(res.data)
      setLines(res.data.lines.map((l, i) => ({ ...l, _key: i })))
      setSeq(res.data.lines.length)
      form.setFieldsValue({ ...res.data, jnl_date: dayjs(res.data.jnl_date) })
      setMode('view')
    } catch {
      message.error('載入傳票失敗')
      onClose()
    } finally {
      setLoading(false)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [form])

  useEffect(() => {
    if (!open) return
    setActiveJnlNo(jnlNo)
    load(jnlNo)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, jnlNo, load])

  const editing = mode === 'edit' || mode === 'create'
  const isAutoPosted = header && header.jnl_bill_type !== 0

  const debitTotal = lines.reduce((s, l) => s + (Number(l.jnd_amount) > 0 ? Number(l.jnd_amount) : 0), 0)
  const creditTotal = lines.reduce((s, l) => s + (Number(l.jnd_amount) < 0 ? -Number(l.jnd_amount) : 0), 0)
  const balance = debitTotal - creditTotal

  const updateLine = (key, patch) => {
    setLines((prev) => prev.map((l) => (l._key === key ? { ...l, ...patch } : l)))
  }

  const handleRemoveLine = (key) => setLines((prev) => prev.filter((l) => l._key !== key))

  const handleAddLine = () => {
    setLines((prev) => [...prev, { _key: seq, act_no: null, jnd_desc: null, jnd_amount: 0 }])
    setSeq((s) => s + 1)
  }

  const handleEdit = () => setMode('edit')
  const handleAbort = () => {
    if (isNew) { onClose(); return }
    load(activeJnlNo)
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
      if (lines.length === 0) { message.error('至少需要一筆分錄'); return }
      for (const l of lines) {
        if (!l.act_no) { message.error('每筆分錄都必須選擇科目'); return }
        if (!Number(l.jnd_amount)) { message.error('明細金額不可為0'); return }
      }
      const payload = {
        jnl_date: values.jnl_date.format('YYYY-MM-DD'),
        jnl_desc: values.jnl_desc || null,
        lines: lines.map((l) => ({
          act_no: l.act_no,
          jnd_amount: Number(l.jnd_amount) || 0,
          jnd_desc: l.jnd_desc || null,
        })),
      }
      setSaving(true)
      if (isNew) {
        const res = await acntJournalApi.create(payload)
        message.success('新增成功')
        setActiveJnlNo(res.data.jnl_no)
        await load(res.data.jnl_no)
      } else {
        await acntJournalApi.update(activeJnlNo, payload)
        message.success('更新成功')
        await load(activeJnlNo)
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
      title: `確定刪除傳票「${activeJnlNo}」？`,
      okText: '刪除',
      okButtonProps: { danger: true },
      cancelText: '取消',
      onOk: async () => {
        try {
          await acntJournalApi.remove(activeJnlNo)
          message.success('刪除成功')
          onClose()
        } catch (err) {
          message.error(err.response?.data?.detail || '刪除失敗')
        }
      },
    })
  }

  const lineColumns = [
    { title: '序號', width: 50, render: (_, __, i) => i + 1 },
    {
      title: '科目', dataIndex: 'act_no', width: 220,
      render: (v, r) => editing ? (
        <SearchSelect
          fetcher={(q) => acntAccountApi.list({ q, page_size: 20 })}
          valueField="act_no"
          labelFn={(a) => `${a.act_no} ${a.act_name}`}
          value={v}
          initialLabel={r.act_name && `${v} ${r.act_name}`}
          onChange={(val) => updateLine(r._key, { act_no: val })}
          placeholder="搜尋科目編號/名稱"
          style={{ width: '100%' }}
        />
      ) : `${v} ${r.act_name || ''}`,
    },
    {
      title: '摘要', dataIndex: 'jnd_desc',
      render: (v, r) => editing ? (
        <Input size="small" value={v} maxLength={200} onChange={(e) => updateLine(r._key, { jnd_desc: e.target.value })} />
      ) : v,
    },
    {
      title: '借方', width: 130, align: 'right',
      render: (_, r) => {
        const amt = Number(r.jnd_amount) || 0
        if (!editing) return amt > 0 ? amt.toLocaleString() : ''
        return (
          <InputNumber
            size="small" style={{ width: '100%' }} min={0}
            value={amt > 0 ? amt : null}
            onChange={(val) => updateLine(r._key, { jnd_amount: val || 0 })}
          />
        )
      },
    },
    {
      title: '貸方', width: 130, align: 'right',
      render: (_, r) => {
        const amt = Number(r.jnd_amount) || 0
        if (!editing) return amt < 0 ? (-amt).toLocaleString() : ''
        return (
          <InputNumber
            size="small" style={{ width: '100%' }} min={0}
            value={amt < 0 ? -amt : null}
            onChange={(val) => updateLine(r._key, { jnd_amount: val ? -val : 0 })}
          />
        )
      },
    },
    ...(editing ? [{
      title: '', width: 40,
      render: (_, r) => <Button type="text" size="small" danger icon={<DeleteOutlined />} onClick={() => handleRemoveLine(r._key)} />,
    }] : []),
  ]

  const hasRecord = !isNew && !!header

  return (
    <Modal
      open={open}
      onCancel={requestClose}
      footer={null}
      width={860}
      title={header ? `傳票維護 — ${header.jnl_no}` : '傳票維護 — 新增'}
      destroyOnHidden
      maskClosable={false}
    >
      <Form form={form} layout="vertical" size="small" disabled={!editing}>
        <Row gutter={8}>
          <Col span={6}>
            <Form.Item name="jnl_date" label="傳票日期" rules={[{ required: true, message: '必填' }]}>
              <DatePicker style={{ width: '100%' }} />
            </Form.Item>
          </Col>
          <Col span={18}>
            <Form.Item name="jnl_desc" label="摘要">
              <Input maxLength={200} />
            </Form.Item>
          </Col>
        </Row>
      </Form>

      {isAutoPosted && (
        <Text type="warning" style={{ display: 'block', marginBottom: 8 }}>
          此傳票由交易單據自動過帳產生，修改或刪除不會回頭更新原始單據的狀態，請謹慎操作。
        </Text>
      )}

      {editing && (
        <Row justify="end" style={{ marginBottom: 8 }}>
          <Button type="dashed" size="small" icon={<PlusOutlined />} onClick={handleAddLine}>新增分錄</Button>
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

      <Row justify="end" style={{ marginTop: 8 }}>
        <Space size="large">
          <Text>借方合計：{debitTotal.toLocaleString()}</Text>
          <Text>貸方合計：{creditTotal.toLocaleString()}</Text>
          <Text strong type={balance === 0 ? 'success' : 'danger'}>差額：{balance.toLocaleString()}</Text>
        </Space>
      </Row>

      <Row justify="space-between" align="middle" style={{ marginTop: 12 }}>
        <Col>
          <Space wrap>
            {!editing && (
              <>
                <Button size="small" icon={<EditOutlined />} disabled={!hasRecord} onClick={handleEdit}>修改</Button>
                <Button size="small" danger icon={<DeleteOutlined />} disabled={!hasRecord} onClick={handleDelete}>刪除</Button>
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

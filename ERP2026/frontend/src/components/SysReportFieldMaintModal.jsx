import { useState, useEffect, useCallback } from 'react'
import { Modal, Table, Button, Space, Popconfirm, message, Col, Tag } from 'antd'
import { PlusOutlined, EditOutlined, DeleteOutlined } from '@ant-design/icons'
import { sysReportApi } from '../api/sysreport'
import SysReportFieldFormModal from './SysReportFieldFormModal'

export default function SysReportFieldMaintModal({ open, report, onCancel }) {
  const [fields, setFields] = useState([])
  const [loading, setLoading] = useState(false)

  const [formOpen, setFormOpen] = useState(false)
  const [editField, setEditField] = useState(null)
  const [formLoading, setFormLoading] = useState(false)

  const srpId = report?.srp_id

  const fetchFields = useCallback(async () => {
    if (!srpId) return
    setLoading(true)
    try {
      const res = await sysReportApi.listFields(srpId)
      setFields(res.data)
    } catch {
      message.error('載入查詢欄位失敗')
    } finally {
      setLoading(false)
    }
  }, [srpId])

  useEffect(() => {
    if (open) fetchFields()
  }, [open, fetchFields])

  const openCreate = () => { setEditField(null); setFormOpen(true) }
  const openEdit = (record) => { setEditField(record); setFormOpen(true) }

  const handleFormOk = async (values) => {
    setFormLoading(true)
    try {
      if (editField) {
        await sysReportApi.updateField(srpId, editField.srf_seqno, values)
        message.success('更新成功')
      } else {
        await sysReportApi.createField(srpId, values)
        message.success('新增成功')
      }
      setFormOpen(false)
      fetchFields()
    } catch (err) {
      message.error(err.response?.data?.detail || (editField ? '更新失敗' : '新增失敗'))
    } finally {
      setFormLoading(false)
    }
  }

  const handleDelete = async (srfSeqno) => {
    try {
      await sysReportApi.removeField(srpId, srfSeqno)
      message.success('刪除成功')
      fetchFields()
    } catch {
      message.error('刪除失敗')
    }
  }

  const columns = [
    { title: '順序', dataIndex: 'srf_disporder', key: 'srf_disporder', width: 60 },
    { title: '欄位', dataIndex: 'srf_fieldname', key: 'srf_fieldname', width: 110 },
    { title: '別名', dataIndex: 'srf_tablealias', key: 'srf_tablealias', width: 60 },
    { title: '顯示名稱', dataIndex: 'srf_dispname', key: 'srf_dispname', width: 110 },
    { title: '控制項', dataIndex: 'srf_controltype', key: 'srf_controltype', width: 90 },
    { title: '查詢型態', dataIndex: 'srf_querytype', key: 'srf_querytype', width: 100 },
    {
      title: '必要', dataIndex: 'srf_ismustcriteria', key: 'srf_ismustcriteria', width: 60,
      render: (v) => (v ? <Tag color="red">是</Tag> : <Tag>否</Tag>),
    },
    {
      title: '條件', dataIndex: 'srf_iswhere', key: 'srf_iswhere', width: 60,
      render: (v) => (v ? <Tag color="blue">是</Tag> : <Tag>否</Tag>),
    },
    {
      title: '排序', dataIndex: 'srf_issort', key: 'srf_issort', width: 60,
      render: (v) => (v ? <Tag color="green">是</Tag> : <Tag>否</Tag>),
    },
    {
      title: '操作', key: 'action', width: 140, fixed: 'right',
      render: (_, record) => (
        <Space size={4}>
          <Button type="link" size="small" icon={<EditOutlined />} onClick={() => openEdit(record)}>編輯</Button>
          <Popconfirm title="確定刪除此查詢欄位？" okText="刪除" cancelText="取消"
            okButtonProps={{ danger: true }} onConfirm={() => handleDelete(record.srf_seqno)}>
            <Button type="link" size="small" danger icon={<DeleteOutlined />}>刪除</Button>
          </Popconfirm>
        </Space>
      ),
    },
  ]

  return (
    <>
      <Modal
        title={`查詢欄位維護 — ${report?.srp_name ?? ''} (${report?.srp_code ?? ''})`}
        open={open}
        onCancel={onCancel}
        footer={<Button onClick={onCancel}>關閉</Button>}
        width={1080}
        destroyOnHidden
      >
        <Col style={{ textAlign: 'right', marginBottom: 12 }}>
          <Button type="primary" icon={<PlusOutlined />} onClick={openCreate}>新增查詢欄位</Button>
        </Col>
        <Table
          rowKey="srf_seqno"
          columns={columns}
          dataSource={fields}
          loading={loading}
          size="small"
          pagination={false}
          scroll={{ x: 900 }}
        />
      </Modal>

      <SysReportFieldFormModal
        open={formOpen}
        srpId={srpId}
        record={editField}
        loading={formLoading}
        onOk={handleFormOk}
        onCancel={() => setFormOpen(false)}
      />
    </>
  )
}

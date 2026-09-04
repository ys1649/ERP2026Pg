import { useState, useEffect, useCallback } from 'react'
import { Card, Table, Button, Space, Input, Form, Row, Col, Popconfirm, message, Tag, Typography } from 'antd'
import {
  SearchOutlined, PlusOutlined, EditOutlined, DeleteOutlined, ReloadOutlined,
  UnorderedListOutlined, BuildOutlined, ExperimentOutlined,
} from '@ant-design/icons'
import { sysReportApi } from '../api/sysreport'
import SysReportFormModal from '../components/SysReportFormModal'
import SysReportFieldMaintModal from '../components/SysReportFieldMaintModal'
import SysReportDesigner from '../components/SysReportDesigner'
import { SysReportQueryModal } from '../components/SysReportQuery'

const { Title, Text } = Typography

export default function SysReportMaster() {
  const [form] = Form.useForm()
  const [data, setData] = useState([])
  const [total, setTotal] = useState(0)
  const [page, setPage] = useState(1)
  const [pageSize, setPageSize] = useState(20)
  const [tableLoading, setTableLoading] = useState(false)
  const [searchParams, setSearchParams] = useState({})

  const [formOpen, setFormOpen] = useState(false)
  const [editRecord, setEditRecord] = useState(null)
  const [formLoading, setFormLoading] = useState(false)

  const [fieldMaintOpen, setFieldMaintOpen] = useState(false)
  const [designerOpen, setDesignerOpen] = useState(false)
  const [testOpen, setTestOpen] = useState(false)
  const [activeRecord, setActiveRecord] = useState(null)

  const fetchData = useCallback(async (params = searchParams, pg = page, ps = pageSize) => {
    setTableLoading(true)
    try {
      const res = await sysReportApi.list({ ...params, page: pg, page_size: ps })
      setData(res.data.data)
      setTotal(res.data.total)
    } catch {
      message.error('載入資料失敗')
    } finally {
      setTableLoading(false)
    }
  }, [searchParams, page, pageSize])

  useEffect(() => { fetchData() }, [fetchData])

  const handleSearch = (values) => {
    const params = { q: values.q?.trim() || undefined }
    setSearchParams(params)
    setPage(1)
    fetchData(params, 1, pageSize)
  }

  const handleReset = () => {
    form.resetFields()
    setSearchParams({})
    setPage(1)
    fetchData({}, 1, pageSize)
  }

  const openCreate = () => { setEditRecord(null); setFormOpen(true) }
  const openEdit = (record) => { setEditRecord(record); setFormOpen(true) }

  const handleFormOk = async (values) => {
    setFormLoading(true)
    try {
      if (editRecord) {
        await sysReportApi.update(editRecord.srp_id, values)
        message.success('更新成功')
      } else {
        await sysReportApi.create(values)
        message.success('新增成功')
      }
      setFormOpen(false)
      fetchData()
    } catch (err) {
      message.error(err.response?.data?.detail || (editRecord ? '更新失敗' : '新增失敗'))
    } finally {
      setFormLoading(false)
    }
  }

  const handleDelete = async (srpId) => {
    try {
      await sysReportApi.remove(srpId)
      message.success('刪除成功')
      fetchData()
    } catch {
      message.error('刪除失敗')
    }
  }

  const columns = [
    {
      title: '報表編號', dataIndex: 'srp_code', key: 'srp_code', width: 160,
      render: (v) => <Tag color="blue">{v}</Tag>,
    },
    { title: '報表名稱', dataIndex: 'srp_name', key: 'srp_name', width: 200 },
    { title: '報表說明', dataIndex: 'srp_description', key: 'srp_description', ellipsis: true },
    {
      title: '操作', key: 'action', width: 320, fixed: 'right',
      render: (_, record) => (
        <Space size={4}>
          <Button type="link" size="small" icon={<UnorderedListOutlined />}
            onClick={() => { setActiveRecord(record); setFieldMaintOpen(true) }}>查詢欄位</Button>
          <Button type="link" size="small" icon={<BuildOutlined />}
            onClick={() => { setActiveRecord(record); setDesignerOpen(true) }}>設計</Button>
          <Button type="link" size="small" icon={<ExperimentOutlined />}
            onClick={() => { setActiveRecord(record); setTestOpen(true) }}>測試</Button>
          <Button type="link" size="small" icon={<EditOutlined />} onClick={() => openEdit(record)}>編輯</Button>
          <Popconfirm
            title={`確定刪除「${record.srp_name}」？`}
            okText="刪除" cancelText="取消" okButtonProps={{ danger: true }}
            onConfirm={() => handleDelete(record.srp_id)}
          >
            <Button type="link" size="small" danger icon={<DeleteOutlined />}>刪除</Button>
          </Popconfirm>
        </Space>
      ),
    },
  ]

  return (
    <>
      <Card styles={{ body: { paddingBottom: 0 } }} style={{ marginBottom: 16 }}>
        <Title level={4} style={{ margin: 0 }}>系統報表定義</Title>
      </Card>

      <Card style={{ marginBottom: 16 }}>
        <Form form={form} layout="inline" onFinish={handleSearch}>
          <Form.Item name="q" label="關鍵字">
            <Input
              placeholder="報表編號 / 名稱"
              allowClear
              style={{ width: 260 }}
              prefix={<SearchOutlined style={{ color: '#bbb' }} />}
            />
          </Form.Item>
          <Form.Item>
            <Space>
              <Button type="primary" htmlType="submit" icon={<SearchOutlined />}>查詢</Button>
              <Button icon={<ReloadOutlined />} onClick={handleReset}>重設</Button>
            </Space>
          </Form.Item>
        </Form>
      </Card>

      <Card>
        <Row justify="space-between" align="middle" style={{ marginBottom: 12 }}>
          <Col>
            <Text type="secondary">共 <strong>{total}</strong> 筆</Text>
          </Col>
          <Col>
            <Button type="primary" icon={<PlusOutlined />} onClick={openCreate}>新增系統報表</Button>
          </Col>
        </Row>

        <Table
          rowKey="srp_id"
          columns={columns}
          dataSource={data}
          loading={tableLoading}
          size="small"
          scroll={{ x: 900 }}
          pagination={{
            current: page,
            pageSize,
            total,
            showSizeChanger: true,
            showQuickJumper: true,
            showTotal: (t) => `共 ${t} 筆`,
            onChange: (p, ps) => { setPage(p); setPageSize(ps); fetchData(searchParams, p, ps) },
          }}
        />
      </Card>

      <SysReportFormModal
        open={formOpen}
        record={editRecord}
        loading={formLoading}
        onOk={handleFormOk}
        onCancel={() => setFormOpen(false)}
      />

      <SysReportFieldMaintModal
        open={fieldMaintOpen}
        report={activeRecord}
        onCancel={() => setFieldMaintOpen(false)}
      />

      <SysReportDesigner
        open={designerOpen}
        report={activeRecord}
        onClose={() => setDesignerOpen(false)}
      />

      <SysReportQueryModal
        open={testOpen}
        srpId={activeRecord?.srp_id}
        title={`測試 — ${activeRecord?.srp_name ?? ''}`}
        onCancel={() => setTestOpen(false)}
      />
    </>
  )
}

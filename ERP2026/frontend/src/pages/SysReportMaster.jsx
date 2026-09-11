import { useState, useEffect, useCallback } from 'react'
import { useNavigate, useSearchParams } from 'react-router-dom'
import { Card, Table, Button, Space, Input, Form, Row, Col, Popconfirm, message, Tag, Typography } from 'antd'
import {
  SearchOutlined, PlusOutlined, EditOutlined, DeleteOutlined, ReloadOutlined,
  UnorderedListOutlined, BuildOutlined, ExperimentOutlined, CopyOutlined,
} from '@ant-design/icons'
import { sysReportApi } from '../api/sysreport'
import SysReportFormModal from '../components/SysReportFormModal'
import SysReportCopyModal from '../components/SysReportCopyModal'
import SysReportFieldMaintModal from '../components/SysReportFieldMaintModal'
import { SysReportQueryModal } from '../components/SysReportQuery'

const { Title, Text } = Typography

export default function SysReportMaster() {
  const navigate = useNavigate()
  const [urlSearchParams, setUrlSearchParams] = useSearchParams()
  const initialQ = urlSearchParams.get('q') || ''
  const [form] = Form.useForm()
  const [data, setData] = useState([])
  const [total, setTotal] = useState(0)
  const [tableLoading, setTableLoading] = useState(false)
  const [searchParams, setSearchParams] = useState(initialQ ? { q: initialQ } : {})

  const [formOpen, setFormOpen] = useState(false)
  const [editRecord, setEditRecord] = useState(null)
  const [formLoading, setFormLoading] = useState(false)

  const [copyOpen, setCopyOpen] = useState(false)
  const [copyRecord, setCopyRecord] = useState(null)
  const [copyLoading, setCopyLoading] = useState(false)

  const [fieldMaintOpen, setFieldMaintOpen] = useState(false)
  const [testOpen, setTestOpen] = useState(false)
  const [activeRecord, setActiveRecord] = useState(null)

  const fetchData = useCallback(async (params = searchParams) => {
    setTableLoading(true)
    try {
      const res = await sysReportApi.list(params)
      setData(res.data.data)
      setTotal(res.data.total)
    } catch {
      message.error('載入資料失敗')
    } finally {
      setTableLoading(false)
    }
  }, [searchParams])

  useEffect(() => { fetchData() }, [fetchData])

  const handleSearch = (values) => {
    const q = values.q?.trim() || undefined
    const params = { q }
    setSearchParams(params)
    setUrlSearchParams(q ? { q } : {})
    fetchData(params)
  }

  const handleReset = () => {
    form.resetFields()
    setSearchParams({})
    setUrlSearchParams({})
    fetchData({})
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

  const openCopy = (record) => { setCopyRecord(record); setCopyOpen(true) }

  const handleCopyOk = async (values) => {
    setCopyLoading(true)
    try {
      await sysReportApi.copy(copyRecord.srp_id, values)
      message.success('複製成功')
      setCopyOpen(false)
      fetchData()
    } catch (err) {
      message.error(err.response?.data?.detail || '複製失敗')
    } finally {
      setCopyLoading(false)
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
    { title: '報表說明', dataIndex: 'srp_description', key: 'srp_description', width: 140, ellipsis: true },
    {
      title: '操作', key: 'action', width: 380,
      render: (_, record) => (
        <Space size={4}>
          <Button type="link" size="small" icon={<UnorderedListOutlined />}
            onClick={() => { setActiveRecord(record); setFieldMaintOpen(true) }}>查詢欄位</Button>
          <Button type="link" size="small" icon={<BuildOutlined />}
            onClick={() => navigate(`/system/report/design/${record.srp_id}`)}>設計</Button>
          <Button type="link" size="small" icon={<ExperimentOutlined />}
            onClick={() => { setActiveRecord(record); setTestOpen(true) }}>測試</Button>
          <Button type="link" size="small" icon={<EditOutlined />} onClick={() => openEdit(record)}>編輯</Button>
          <Button type="link" size="small" icon={<CopyOutlined />} onClick={() => openCopy(record)}>複製</Button>
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
        <Form form={form} layout="inline" onFinish={handleSearch} initialValues={{ q: initialQ }}>
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
          pagination={false}
        />
      </Card>

      <SysReportFormModal
        open={formOpen}
        record={editRecord}
        loading={formLoading}
        onOk={handleFormOk}
        onCancel={() => setFormOpen(false)}
      />

      <SysReportCopyModal
        open={copyOpen}
        record={copyRecord}
        loading={copyLoading}
        onOk={handleCopyOk}
        onCancel={() => setCopyOpen(false)}
      />

      <SysReportFieldMaintModal
        open={fieldMaintOpen}
        report={activeRecord}
        onCancel={() => setFieldMaintOpen(false)}
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

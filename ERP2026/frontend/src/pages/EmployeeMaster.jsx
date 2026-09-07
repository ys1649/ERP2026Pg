import { useState, useEffect, useCallback } from 'react'
import {
  Card, Table, Button, Space, Input, Form, Row, Col,
  Popconfirm, message, Tag, Typography,
} from 'antd'
import {
  SearchOutlined, PlusOutlined, EditOutlined,
  DeleteOutlined, ReloadOutlined,
} from '@ant-design/icons'
import { employeeApi } from '../api/employees'
import EmployeeFormModal from '../components/EmployeeFormModal'

const { Title } = Typography

export default function EmployeeMaster() {
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

  const fetchData = useCallback(async (params = searchParams, pg = page, ps = pageSize) => {
    setTableLoading(true)
    try {
      const res = await employeeApi.list({ ...params, page: pg, page_size: ps })
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
  const openEdit = async (record) => {
    // 列表 API 不回傳密碼欄位，編輯前先取完整資料
    const res = await employeeApi.get(record.epy_no)
    setEditRecord(res.data)
    setFormOpen(true)
  }

  const handleFormOk = async (values) => {
    setFormLoading(true)
    try {
      if (editRecord) {
        await employeeApi.update(editRecord.epy_no, values)
        message.success('更新成功')
      } else {
        await employeeApi.create(values)
        message.success('新增成功')
      }
      setFormOpen(false)
      fetchData()
    } catch (err) {
      const detail = err.response?.data?.detail
      message.error(detail || (editRecord ? '更新失敗' : '新增失敗'))
    } finally {
      setFormLoading(false)
    }
  }

  const handleDelete = async (id) => {
    try {
      await employeeApi.remove(id)
      message.success('刪除成功')
      fetchData()
    } catch {
      message.error('刪除失敗')
    }
  }

  const columns = [
    {
      title: '員工編號', dataIndex: 'epy_no', key: 'epy_no', width: 100,
      render: (v) => <Tag color="blue">{v}</Tag>,
    },
    { title: '姓名', dataIndex: 'epy_name', key: 'epy_name', width: 120 },
    { title: '電話1', dataIndex: 'epy_tel1', key: 'epy_tel1', width: 130 },
    { title: '電話2', dataIndex: 'epy_tel2', key: 'epy_tel2', width: 130 },
    { title: '地址', dataIndex: 'epy_addr', key: 'epy_addr', ellipsis: true },
    {
      title: '允許登入', dataIndex: 'epy_is_can_login', key: 'epy_is_can_login', width: 90,
      render: (v) => <Tag color={v ? 'green' : 'default'}>{v ? '是' : '否'}</Tag>,
    },
    {
      title: '操作', key: 'action', width: 100, fixed: 'right',
      render: (_, record) => (
        <Space size={4}>
          <Button type="link" size="small" icon={<EditOutlined />}
            onClick={() => openEdit(record)}>編輯</Button>
          <Popconfirm
            title={`確定刪除「${record.epy_name}」？`}
            okText="刪除" cancelText="取消" okButtonProps={{ danger: true }}
            onConfirm={() => handleDelete(record.epy_no)}
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
        <Title level={4} style={{ margin: 0 }}>員工基本資料設定</Title>
      </Card>

      <Card style={{ marginBottom: 16 }}>
        <Form form={form} layout="inline" onFinish={handleSearch}>
          <Form.Item name="q" label="關鍵字">
            <Input
              placeholder="員工編號 / 姓名"
              allowClear
              style={{ width: 280 }}
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
            <Typography.Text type="secondary">
              共 <strong>{total}</strong> 筆
            </Typography.Text>
          </Col>
          <Col>
            <Button type="primary" icon={<PlusOutlined />} onClick={openCreate}>
              新增員工
            </Button>
          </Col>
        </Row>

        <Table
          rowKey="epy_no"
          columns={columns}
          dataSource={data}
          loading={tableLoading}
          size="small"
          scroll={{ x: 800 }}
          pagination={{
            current: page,
            pageSize,
            total,
            showSizeChanger: true,
            showQuickJumper: true,
            showTotal: (t) => `共 ${t} 筆`,
            onChange: (p, ps) => {
              setPage(p)
              setPageSize(ps)
              fetchData(searchParams, p, ps)
            },
          }}
        />
      </Card>

      <EmployeeFormModal
        open={formOpen}
        record={editRecord}
        loading={formLoading}
        onOk={handleFormOk}
        onCancel={() => setFormOpen(false)}
      />
    </>
  )
}

import { useState, useEffect, useCallback } from 'react'
import {
  Card, Table, Button, Space, Input, Form, Row, Col,
  Popconfirm, message, Tag, Typography,
} from 'antd'
import {
  SearchOutlined, PlusOutlined, EditOutlined,
  DeleteOutlined, ReloadOutlined,
} from '@ant-design/icons'
import { acntAccountApi } from '../api/acntAccounts'
import AcntAccountFormModal from '../components/AcntAccountFormModal'

const { Title } = Typography

export default function AcntAccountMaster() {
  const [form] = Form.useForm()
  const [data, setData] = useState([])
  const [total, setTotal] = useState(0)
  const [page, setPage] = useState(1)
  const [pageSize, setPageSize] = useState(50)
  const [tableLoading, setTableLoading] = useState(false)
  const [searchParams, setSearchParams] = useState({})

  const [formOpen, setFormOpen] = useState(false)
  const [editRecord, setEditRecord] = useState(null)
  const [formLoading, setFormLoading] = useState(false)

  const fetchData = useCallback(async (params = searchParams, pg = page, ps = pageSize) => {
    setTableLoading(true)
    try {
      const res = await acntAccountApi.list({ ...params, page: pg, page_size: ps })
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
        await acntAccountApi.update(editRecord.act_no, values)
        message.success('更新成功')
      } else {
        await acntAccountApi.create(values)
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
      await acntAccountApi.remove(id)
      message.success('刪除成功')
      fetchData()
    } catch {
      message.error('刪除失敗')
    }
  }

  const columns = [
    {
      title: '科目編號', dataIndex: 'act_no', key: 'act_no', width: 110,
      render: (v) => <Tag color="blue">{v}</Tag>,
    },
    { title: '科目名稱', dataIndex: 'act_name', key: 'act_name', width: 180 },
    { title: '科目類別', dataIndex: 'typ_name', key: 'typ_name', width: 120 },
    {
      title: '反轉科目', dataIndex: 'act_category_reverse', key: 'act_category_reverse', width: 90,
      render: (v) => (v ? <Tag color="orange">是</Tag> : '否'),
    },
    {
      title: '現金科目', dataIndex: 'act_category_cash', key: 'act_category_cash', width: 90,
      render: (v) => (v ? <Tag color="green">是</Tag> : '否'),
    },
    { title: '說明', dataIndex: 'act_desc', key: 'act_desc', ellipsis: true },
    {
      title: '操作', key: 'action', width: 170, fixed: 'right',
      render: (_, record) => (
        <Space size={4}>
          <Button type="link" size="small" icon={<EditOutlined />}
            onClick={() => openEdit(record)}>編輯</Button>
          <Popconfirm
            title={`確定刪除「${record.act_name}」？`}
            okText="刪除" cancelText="取消" okButtonProps={{ danger: true }}
            onConfirm={() => handleDelete(record.act_no)}
          >
            <Button type="link" size="small" danger icon={<DeleteOutlined />}>刪除</Button>
          </Popconfirm>
        </Space>
      ),
    },
  ]

  return (
    <>
      <Card styles={{ body: { padding: '12px 24px' } }} style={{ marginBottom: 8 }}>
        <Row justify="space-between" align="middle" gutter={[16, 8]} wrap>
          <Col flex="none">
            <Space direction="vertical" size={0}>
              <Title level={4} style={{ margin: 0 }}>會計科目設定</Title>
              <Typography.Text type="secondary">共 <strong>{total}</strong> 筆</Typography.Text>
            </Space>
          </Col>
          <Col flex="auto">
            <Form form={form} layout="inline" onFinish={handleSearch}>
              <Form.Item name="q" label="關鍵字" style={{ marginBottom: 0 }}>
                <Input
                  placeholder="科目編號 / 科目名稱"
                  allowClear
                  style={{ width: 280 }}
                  prefix={<SearchOutlined style={{ color: '#bbb' }} />}
                />
              </Form.Item>
              <Form.Item style={{ marginBottom: 0 }}>
                <Space>
                  <Button type="primary" htmlType="submit" icon={<SearchOutlined />}>查詢</Button>
                  <Button icon={<ReloadOutlined />} onClick={handleReset}>重設</Button>
                </Space>
              </Form.Item>
            </Form>
          </Col>
          <Col flex="none">
            <Button type="primary" icon={<PlusOutlined />} onClick={openCreate}>
              新增會計科目
            </Button>
          </Col>
        </Row>
      </Card>

      <Card styles={{ body: { padding: '8px 16px' } }}>
        <Table
          rowKey="act_no"
          columns={columns}
          dataSource={data}
          loading={tableLoading}
          size="small"
          scroll={{ x: 870, y: 'calc(100vh - 400px)' }}
          pagination={{
            current: page,
            pageSize,
            total,
            showSizeChanger: true,
            pageSizeOptions: ['50', '100', '200'],
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

      <AcntAccountFormModal
        open={formOpen}
        record={editRecord}
        loading={formLoading}
        onOk={handleFormOk}
        onCancel={() => setFormOpen(false)}
      />
    </>
  )
}

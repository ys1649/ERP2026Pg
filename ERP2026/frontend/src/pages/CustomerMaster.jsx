import { useState, useEffect, useCallback } from 'react'
import {
  Card, Table, Button, Space, Input, Form, Row, Col,
  Popconfirm, message, Tag, Typography, Tooltip, Dropdown,
} from 'antd'
import {
  SearchOutlined, PlusOutlined, EditOutlined,
  DeleteOutlined, PrinterOutlined, ReloadOutlined, DownOutlined, ToolOutlined,
} from '@ant-design/icons'
import { customerApi } from '../api/customers'
import { reportApi } from '../api/reports'
import CustomerFormModal from '../components/CustomerFormModal'
import CustomerReportPreview from '../components/CustomerReportPreview'
import CustomerReport from '../components/CustomerReport'

const { Title } = Typography

function buildSortParam(sorter) {
  const arr = Array.isArray(sorter) ? sorter : sorter ? [sorter] : []
  return arr
    .filter((s) => s.order && s.field)
    .map((s) => `${s.field}:${s.order === 'ascend' ? 'asc' : 'desc'}`)
    .join(',')
}

export default function CustomerMaster() {
  const [form] = Form.useForm()
  const [data, setData] = useState([])
  const [total, setTotal] = useState(0)
  const [page, setPage] = useState(1)
  const [pageSize, setPageSize] = useState(50)
  const [tableLoading, setTableLoading] = useState(false)
  const [searchParams, setSearchParams] = useState({})
  const [sort, setSort] = useState('')

  // Form modal
  const [formOpen, setFormOpen] = useState(false)
  const [editRecord, setEditRecord] = useState(null)
  const [formLoading, setFormLoading] = useState(false)

  // Report preview
  const [reportFiles, setReportFiles] = useState([])
  const [selectedReport, setSelectedReport] = useState(null)
  const [previewOpen, setPreviewOpen] = useState(false)
  const [designerOpen, setDesignerOpen] = useState(false)

  // ── 查詢 ────────────────────────────────────────────────
  const fetchData = useCallback(async (params = searchParams, pg = page, ps = pageSize, srt = sort) => {
    setTableLoading(true)
    try {
      const res = await customerApi.list({ ...params, sort: srt || undefined, page: pg, page_size: ps })
      setData(res.data.data)
      setTotal(res.data.total)
    } catch {
      message.error('載入資料失敗')
    } finally {
      setTableLoading(false)
    }
  }, [searchParams, page, pageSize, sort])

  useEffect(() => { fetchData() }, [fetchData])

  useEffect(() => {
    reportApi.listCustomer()
      .then((res) => setReportFiles(Array.isArray(res.data) ? res.data : []))
      .catch(() => {})
  }, [])

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

  // ── 新增 / 編輯 ─────────────────────────────────────────
  const openCreate = () => { setEditRecord(null); setFormOpen(true) }
  const openEdit = (record) => { setEditRecord(record); setFormOpen(true) }

  const handleFormOk = async (values) => {
    setFormLoading(true)
    try {
      if (editRecord) {
        await customerApi.update(editRecord.cum_no, values)
        message.success('更新成功')
      } else {
        await customerApi.create(values)
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

  // ── 刪除 ────────────────────────────────────────────────
  const handleDelete = async (id) => {
    try {
      await customerApi.remove(id)
      message.success('刪除成功')
      fetchData()
    } catch {
      message.error('刪除失敗')
    }
  }

  const handleTableChange = (pagination, _filters, sorter) => {
    const srt = buildSortParam(sorter)
    setPage(pagination.current)
    setPageSize(pagination.pageSize)
    setSort(srt)
    fetchData(searchParams, pagination.current, pagination.pageSize, srt)
  }

  // ── 表格欄位 ─────────────────────────────────────────────
  const columns = [
    {
      title: '客戶編號', dataIndex: 'cum_no', key: 'cum_no', width: 100, sorter: true,
      render: (v) => <Tag color="blue">{v}</Tag>,
    },
    {
      title: '客戶名稱', dataIndex: 'cum_name', key: 'cum_name', ellipsis: true, sorter: true,
      render: (v) => <Tooltip title={v}>{v}</Tooltip>,
    },
    { title: '負責人', dataIndex: 'cum_president', key: 'cum_president', width: 90, sorter: true },
    { title: '聯絡人', dataIndex: 'cum_contant', key: 'cum_contant', width: 90, sorter: true },
    { title: '電話', dataIndex: 'cum_tel1', key: 'cum_tel1', width: 130, sorter: true },
    { title: '統一編號', dataIndex: 'cum_uniform_no', key: 'cum_uniform_no', width: 100, sorter: true },
    {
      title: '公司地址', dataIndex: 'cum_addr', key: 'cum_addr', ellipsis: true, sorter: true,
      render: (v) => <Tooltip title={v}>{v}</Tooltip>,
    },
    {
      title: '操作', key: 'action', width: 170, fixed: 'right',
      render: (_, record) => (
        <Space size={4}>
          <Button type="link" size="small" icon={<EditOutlined />}
            onClick={() => openEdit(record)}>編輯</Button>
          <Popconfirm
            title={`確定刪除「${record.cum_name}」？`}
            okText="刪除" cancelText="取消" okButtonProps={{ danger: true }}
            onConfirm={() => handleDelete(record.cum_no)}
          >
            <Button type="link" size="small" danger icon={<DeleteOutlined />}>刪除</Button>
          </Popconfirm>
        </Space>
      ),
    },
  ]

  return (
    <>
      {/* ── 頁面標題列 ── */}
      <Card styles={{ body: { padding: '12px 24px' } }} style={{ marginBottom: 8 }}>
        <Row justify="space-between" align="middle" gutter={[16, 8]} wrap>
          <Col flex="none">
            <Space direction="vertical" size={0}>
              <Title level={4} style={{ margin: 0 }}>客戶資料維護</Title>
              <Typography.Text type="secondary">共 <strong>{total}</strong> 筆</Typography.Text>
            </Space>
          </Col>
          <Col flex="auto">
            <Form form={form} layout="inline" onFinish={handleSearch}>
              <Form.Item name="q" label="關鍵字" style={{ marginBottom: 0 }}>
                <Input
                  placeholder="客戶編號 / 客戶名稱 / 統一編號"
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
            <Space>
              <Button type="primary" icon={<PlusOutlined />} onClick={openCreate}>
                新增客戶
              </Button>
              <Dropdown
                menu={{
                  items: [
                    ...reportFiles.map((name) => ({ key: name, label: name })),
                    { type: 'divider' },
                    { key: '__designer__', icon: <ToolOutlined />, label: '報表設計' },
                  ],
                  onClick: ({ key }) => {
                    if (key === '__designer__') {
                      setDesignerOpen(true)
                    } else {
                      setSelectedReport(key)
                      setPreviewOpen(true)
                    }
                  },
                }}
              >
                <Button icon={<PrinterOutlined />}>
                  列印 <DownOutlined />
                </Button>
              </Dropdown>
            </Space>
          </Col>
        </Row>
      </Card>

      {/* ── 資料表格 ── */}
      <Card styles={{ body: { padding: '8px 16px' } }}>
        <Table
          rowKey="cum_no"
          columns={columns}
          dataSource={data}
          loading={tableLoading}
          size="small"
          scroll={{ x: 1170, y: 'calc(100vh - 400px)' }}
          onChange={handleTableChange}
          pagination={{
            current: page,
            pageSize,
            total,
            showSizeChanger: true,
            pageSizeOptions: ['50', '100', '200'],
            showQuickJumper: true,
            showTotal: (t) => `共 ${t} 筆`,
          }}
        />
      </Card>

      {/* ── 新增/編輯 Modal ── */}
      <CustomerFormModal
        open={formOpen}
        record={editRecord}
        loading={formLoading}
        onOk={handleFormOk}
        onCancel={() => setFormOpen(false)}
      />

      {/* ── 列印預覽 Modal ── */}
      <CustomerReportPreview
        key={selectedReport}
        open={previewOpen}
        onClose={() => setPreviewOpen(false)}
        reportName={selectedReport}
        searchParams={searchParams}
      />

      {/* ── 報表設計 Modal ── */}
      <CustomerReport
        open={designerOpen}
        onClose={() => setDesignerOpen(false)}
        searchParams={searchParams}
      />
    </>
  )
}

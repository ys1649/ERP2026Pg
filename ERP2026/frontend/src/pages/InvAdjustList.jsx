import { useState, useEffect, useCallback } from 'react'
import {
  Card, Table, Button, Space, Input, Form, Row, Col,
  message, Tag, Typography, Select,
} from 'antd'
import { SearchOutlined, PlusOutlined, ReloadOutlined } from '@ant-design/icons'
import dayjs from 'dayjs'
import { invAdjustApi } from '../api/invAdjust'
import InvAdjustFormModal from '../components/InvAdjustFormModal'

const { Title } = Typography

const STATUS_TAG = { 0: <Tag color="orange">未確認</Tag>, 1: <Tag color="green">已確認</Tag> }

function buildSortParam(sorter) {
  const arr = Array.isArray(sorter) ? sorter : sorter ? [sorter] : []
  return arr
    .filter((s) => s.order && s.field)
    .map((s) => `${s.field}:${s.order === 'ascend' ? 'asc' : 'desc'}`)
    .join(',')
}

export default function InvAdjustList() {
  const [form] = Form.useForm()
  const [data, setData] = useState([])
  const [total, setTotal] = useState(0)
  const [page, setPage] = useState(1)
  const [pageSize, setPageSize] = useState(20)
  const [tableLoading, setTableLoading] = useState(false)
  const [searchParams, setSearchParams] = useState({})
  const [sort, setSort] = useState('')
  const [modalAdjNo, setModalAdjNo] = useState(null)

  const fetchData = useCallback(async (params = searchParams, pg = page, ps = pageSize, srt = sort) => {
    setTableLoading(true)
    try {
      const res = await invAdjustApi.list({ ...params, sort: srt || undefined, page: pg, page_size: ps })
      setData(res.data.data)
      setTotal(res.data.total)
    } catch {
      message.error('載入資料失敗')
    } finally {
      setTableLoading(false)
    }
  }, [searchParams, page, pageSize, sort])

  useEffect(() => { fetchData() }, [fetchData])

  const handleSearch = (values) => {
    const params = { q: values.q?.trim() || undefined, status: values.status }
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

  const handleTableChange = (pagination, _filters, sorter) => {
    const srt = buildSortParam(sorter)
    setPage(pagination.current)
    setPageSize(pagination.pageSize)
    setSort(srt)
    fetchData(searchParams, pagination.current, pagination.pageSize, srt)
  }

  const columns = [
    { title: '調整單號', dataIndex: 'adj_no', key: 'adj_no', width: 140, sorter: { multiple: 2 } },
    {
      title: '調整日期', dataIndex: 'adj_date', key: 'adj_date', width: 110, sorter: { multiple: 1 }, defaultSortOrder: 'descend',
      render: (v) => dayjs(v).format('YYYY-MM-DD'),
    },
    { title: '摘要', dataIndex: 'adj_desc', key: 'adj_desc', ellipsis: true },
    { title: '品項數', dataIndex: 'line_count', key: 'line_count', width: 90, align: 'right' },
    { title: '狀態', dataIndex: 'adj_status', key: 'adj_status', width: 90, sorter: { multiple: 3 }, render: (v) => STATUS_TAG[v] || v },
  ]

  return (
    <>
      <Card styles={{ body: { padding: '12px 24px' } }} style={{ marginBottom: 8 }}>
        <Row justify="space-between" align="middle" gutter={[16, 8]} wrap>
          <Col flex="none">
            <Space direction="vertical" size={0}>
              <Title level={4} style={{ margin: 0 }}>庫房調整單</Title>
              <Typography.Text type="secondary">共 <strong>{total}</strong> 筆</Typography.Text>
            </Space>
          </Col>
          <Col flex="auto">
            <Form form={form} layout="inline" onFinish={handleSearch}>
              <Form.Item name="q" label="關鍵字" style={{ marginBottom: 0 }}>
                <Input
                  placeholder="調整單號 / 摘要"
                  allowClear
                  style={{ width: 220 }}
                  prefix={<SearchOutlined style={{ color: '#bbb' }} />}
                />
              </Form.Item>
              <Form.Item name="status" label="狀態" style={{ marginBottom: 0 }}>
                <Select
                  allowClear
                  placeholder="全部"
                  style={{ width: 120 }}
                  options={[{ value: 0, label: '未確認' }, { value: 1, label: '已確認' }]}
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
            <Button type="primary" icon={<PlusOutlined />} onClick={() => setModalAdjNo('new')}>
              新增調整單
            </Button>
          </Col>
        </Row>
      </Card>

      <Card styles={{ body: { padding: '8px 16px' } }}>
        <Table
          rowKey="adj_no"
          columns={columns}
          dataSource={data}
          loading={tableLoading}
          size="small"
          scroll={{ x: 700, y: 'calc(100vh - 400px)' }}
          onRow={(record) => ({
            onClick: () => setModalAdjNo(record.adj_no),
            style: { cursor: 'pointer' },
          })}
          onChange={handleTableChange}
          pagination={{
            current: page,
            pageSize,
            total,
            showSizeChanger: true,
            showQuickJumper: true,
            showTotal: (t) => `共 ${t} 筆`,
          }}
        />
      </Card>

      <InvAdjustFormModal
        open={!!modalAdjNo}
        adjNo={modalAdjNo}
        onClose={() => {
          setModalAdjNo(null)
          fetchData()
        }}
      />
    </>
  )
}

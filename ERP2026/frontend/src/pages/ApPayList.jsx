import { useState, useEffect, useCallback } from 'react'
import {
  Card, Table, Button, Space, Input, Form, Row, Col,
  message, Typography, Tooltip,
} from 'antd'
import { SearchOutlined, PlusOutlined, ReloadOutlined } from '@ant-design/icons'
import dayjs from 'dayjs'
import { apPayApi } from '../api/apPay'
import ApPayFormModal from '../components/ApPayFormModal'

const { Title } = Typography

function buildSortParam(sorter) {
  const arr = Array.isArray(sorter) ? sorter : sorter ? [sorter] : []
  return arr
    .filter((s) => s.order && s.field)
    .map((s) => `${s.field}:${s.order === 'ascend' ? 'asc' : 'desc'}`)
    .join(',')
}

export default function ApPayList() {
  const [form] = Form.useForm()
  const [data, setData] = useState([])
  const [total, setTotal] = useState(0)
  const [page, setPage] = useState(1)
  const [pageSize, setPageSize] = useState(20)
  const [tableLoading, setTableLoading] = useState(false)
  const [searchParams, setSearchParams] = useState({})
  const [sort, setSort] = useState('')
  const [modalPayNo, setModalPayNo] = useState(null)

  const fetchData = useCallback(async (params = searchParams, pg = page, ps = pageSize, srt = sort) => {
    setTableLoading(true)
    try {
      const res = await apPayApi.list({ ...params, sort: srt || undefined, page: pg, page_size: ps })
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

  const handleTableChange = (pagination, _filters, sorter) => {
    const srt = buildSortParam(sorter)
    setPage(pagination.current)
    setPageSize(pagination.pageSize)
    setSort(srt)
    fetchData(searchParams, pagination.current, pagination.pageSize, srt)
  }

  const columns = [
    { title: '付款單號', dataIndex: 'pay_no', key: 'pay_no', width: 140, sorter: { multiple: 2 } },
    {
      title: '廠商', dataIndex: 'sup_name', key: 'sup_name', ellipsis: true, sorter: { multiple: 3 },
      render: (v) => <Tooltip title={v}>{v}</Tooltip>,
    },
    {
      title: '付款日期', dataIndex: 'pay_date', key: 'pay_date', width: 110, sorter: { multiple: 1 }, defaultSortOrder: 'descend',
      render: (v) => dayjs(v).format('YYYY-MM-DD'),
    },
    { title: '現金', dataIndex: 'pay_cash', key: 'pay_cash', width: 90, align: 'right', render: (v) => Number(v).toLocaleString() },
    { title: '票據', dataIndex: 'pay_check', key: 'pay_check', width: 90, align: 'right', render: (v) => Number(v).toLocaleString() },
    { title: '付款合計', dataIndex: 'pay_total', key: 'pay_total', width: 100, align: 'right', render: (v) => Number(v).toLocaleString() },
  ]

  return (
    <>
      <Card styles={{ body: { padding: '12px 24px' } }} style={{ marginBottom: 8 }}>
        <Row justify="space-between" align="middle" gutter={[16, 8]} wrap>
          <Col flex="none">
            <Space direction="vertical" size={0}>
              <Title level={4} style={{ margin: 0 }}>進貨付款作業</Title>
              <Typography.Text type="secondary">共 <strong>{total}</strong> 筆</Typography.Text>
            </Space>
          </Col>
          <Col flex="auto">
            <Form form={form} layout="inline" onFinish={handleSearch}>
              <Form.Item name="q" label="關鍵字" style={{ marginBottom: 0 }}>
                <Input
                  placeholder="付款單號 / 廠商編號 / 廠商名稱"
                  allowClear
                  style={{ width: 240 }}
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
            <Button type="primary" icon={<PlusOutlined />} onClick={() => setModalPayNo('new')}>
              新增付款單
            </Button>
          </Col>
        </Row>
      </Card>

      <Card styles={{ body: { padding: '8px 16px' } }}>
        <Table
          rowKey="pay_no"
          columns={columns}
          dataSource={data}
          loading={tableLoading}
          size="small"
          scroll={{ x: 700, y: 'calc(100vh - 400px)' }}
          onRow={(record) => ({
            onClick: () => setModalPayNo(record.pay_no),
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

      <ApPayFormModal
        open={!!modalPayNo}
        payNo={modalPayNo}
        onClose={() => {
          setModalPayNo(null)
          fetchData()
        }}
      />
    </>
  )
}

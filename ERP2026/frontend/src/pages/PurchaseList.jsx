import { useState, useEffect, useCallback } from 'react'
import {
  Card, Table, Button, Space, Input, Form, Row, Col, Select,
  message, Tag, Typography, Tooltip,
} from 'antd'
import { SearchOutlined, PlusOutlined, ReloadOutlined } from '@ant-design/icons'
import dayjs from 'dayjs'
import { poRecvApi } from '../api/poRecv'
import PoRecvFormModal from '../components/PoRecvFormModal'

const { Title } = Typography

const STATUS_TAG = {
  0: <Tag color="orange">未確認</Tag>,
  1: <Tag color="green">已確認</Tag>,
}

function buildSortParam(sorter) {
  const arr = Array.isArray(sorter) ? sorter : sorter ? [sorter] : []
  return arr
    .filter((s) => s.order && s.field)
    .map((s) => `${s.field}:${s.order === 'ascend' ? 'asc' : 'desc'}`)
    .join(',')
}

export default function PurchaseList() {
  const [form] = Form.useForm()
  const [data, setData] = useState([])
  const [total, setTotal] = useState(0)
  const [page, setPage] = useState(1)
  const [pageSize, setPageSize] = useState(20)
  const [tableLoading, setTableLoading] = useState(false)
  const [searchParams, setSearchParams] = useState({})
  const [sort, setSort] = useState('')
  const [modalRcvNo, setModalRcvNo] = useState(null)

  const fetchData = useCallback(async (params = searchParams, pg = page, ps = pageSize, srt = sort) => {
    setTableLoading(true)
    try {
      const res = await poRecvApi.list({ ...params, sort: srt || undefined, page: pg, page_size: ps })
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
    const params = {
      q: values.q?.trim() || undefined,
      status: values.status,
    }
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
    { title: '進貨單號', dataIndex: 'rcv_no', key: 'rcv_no', width: 130, sorter: { multiple: 2 } },
    {
      title: '廠商', dataIndex: 'sup_name', key: 'sup_name', ellipsis: true, sorter: { multiple: 3 },
      render: (v) => <Tooltip title={v}>{v}</Tooltip>,
    },
    {
      title: '進貨日期', dataIndex: 'rcv_date', key: 'rcv_date', width: 110, sorter: { multiple: 1 }, defaultSortOrder: 'descend',
      render: (v) => dayjs(v).format('YYYY-MM-DD'),
    },
    { title: '發票號碼', dataIndex: 'rcv_inv_no', key: 'rcv_inv_no', width: 110, sorter: { multiple: 4 } },
    {
      title: '金額', dataIndex: 'rcv_amount', key: 'rcv_amount', width: 100, align: 'right', sorter: { multiple: 5 },
      render: (v) => Number(v).toLocaleString(),
    },
    {
      title: '未清帳款', dataIndex: 'rcv_not_clean', key: 'rcv_not_clean', width: 100, align: 'right', sorter: { multiple: 6 },
      render: (v) => Number(v).toLocaleString(),
    },
    {
      title: '狀態', dataIndex: 'rcv_status', key: 'rcv_status', width: 90, sorter: { multiple: 7 },
      render: (v) => STATUS_TAG[v] || v,
    },
  ]

  return (
    <>
      <Card styles={{ body: { padding: '12px 24px' } }} style={{ marginBottom: 8 }}>
        <Row justify="space-between" align="middle" gutter={[16, 8]} wrap>
          <Col flex="none">
            <Space direction="vertical" size={0}>
              <Title level={4} style={{ margin: 0 }}>進貨單維護</Title>
              <Typography.Text type="secondary">共 <strong>{total}</strong> 筆</Typography.Text>
            </Space>
          </Col>
          <Col flex="auto">
            <Form form={form} layout="inline" onFinish={handleSearch}>
              <Form.Item name="q" label="關鍵字" style={{ marginBottom: 0 }}>
                <Input
                  placeholder="進貨單號 / 廠商編號 / 廠商名稱 / 發票號碼"
                  allowClear
                  style={{ width: 260 }}
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
            <Button type="primary" icon={<PlusOutlined />} onClick={() => setModalRcvNo('new')}>
              新增進貨單
            </Button>
          </Col>
        </Row>
      </Card>

      <Card styles={{ body: { padding: '8px 16px' } }}>
        <Table
          rowKey="rcv_no"
          columns={columns}
          dataSource={data}
          loading={tableLoading}
          size="small"
          scroll={{ x: 900, y: 'calc(100vh - 400px)' }}
          onRow={(record) => ({
            onClick: () => setModalRcvNo(record.rcv_no),
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

      <PoRecvFormModal
        open={!!modalRcvNo}
        rcvNo={modalRcvNo}
        onClose={() => {
          setModalRcvNo(null)
          fetchData()
        }}
      />
    </>
  )
}

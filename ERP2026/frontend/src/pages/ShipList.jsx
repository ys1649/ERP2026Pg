import { useState, useEffect, useCallback } from 'react'
import {
  Card, Table, Button, Space, Input, Form, Row, Col, Select,
  message, Tag, Typography, Tooltip,
} from 'antd'
import { SearchOutlined, PlusOutlined, ReloadOutlined } from '@ant-design/icons'
import dayjs from 'dayjs'
import { shipApi } from '../api/ship'
import ShipFormModal from '../components/ShipFormModal'

const { Title } = Typography

const STATUS_TAG = {
  0: <Tag color="orange">未確認</Tag>,
  1: <Tag color="green">已確認</Tag>,
}

export default function ShipList() {
  const [form] = Form.useForm()
  const [data, setData] = useState([])
  const [total, setTotal] = useState(0)
  const [page, setPage] = useState(1)
  const [pageSize, setPageSize] = useState(20)
  const [tableLoading, setTableLoading] = useState(false)
  const [searchParams, setSearchParams] = useState({})
  const [modalSmtNo, setModalSmtNo] = useState(null)

  const fetchData = useCallback(async (params = searchParams, pg = page, ps = pageSize) => {
    setTableLoading(true)
    try {
      const res = await shipApi.list({ ...params, page: pg, page_size: ps })
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

  const columns = [
    { title: '出貨單號', dataIndex: 'smt_no', key: 'smt_no', width: 130 },
    {
      title: '客戶', dataIndex: 'cum_name', key: 'cum_name', ellipsis: true,
      render: (v) => <Tooltip title={v}>{v}</Tooltip>,
    },
    { title: '業務員', dataIndex: 'epy_name', key: 'epy_name', width: 90 },
    {
      title: '出貨日期', dataIndex: 'smt_date', key: 'smt_date', width: 110,
      render: (v) => dayjs(v).format('YYYY-MM-DD'),
    },
    { title: '發票號碼', dataIndex: 'smt_inv_no', key: 'smt_inv_no', width: 110 },
    {
      title: '金額', dataIndex: 'smt_amount', key: 'smt_amount', width: 100, align: 'right',
      render: (v) => Number(v).toLocaleString(),
    },
    {
      title: '未清帳款', dataIndex: 'smt_not_clean', key: 'smt_not_clean', width: 100, align: 'right',
      render: (v) => Number(v).toLocaleString(),
    },
    {
      title: '狀態', dataIndex: 'smt_status', key: 'smt_status', width: 90,
      render: (v) => STATUS_TAG[v] || v,
    },
  ]

  return (
    <>
      <Card styles={{ body: { paddingBottom: 0 } }} style={{ marginBottom: 16 }}>
        <Title level={4} style={{ margin: 0 }}>出貨單維護</Title>
      </Card>

      <Card style={{ marginBottom: 16 }}>
        <Form form={form} layout="inline" onFinish={handleSearch}>
          <Form.Item name="q" label="關鍵字">
            <Input
              placeholder="出貨單號 / 客戶編號 / 客戶名稱 / 發票號碼"
              allowClear
              style={{ width: 260 }}
              prefix={<SearchOutlined style={{ color: '#bbb' }} />}
            />
          </Form.Item>
          <Form.Item name="status" label="狀態">
            <Select
              allowClear
              placeholder="全部"
              style={{ width: 120 }}
              options={[{ value: 0, label: '未確認' }, { value: 1, label: '已確認' }]}
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
            <Button type="primary" icon={<PlusOutlined />} onClick={() => setModalSmtNo('new')}>
              新增出貨單
            </Button>
          </Col>
        </Row>

        <Table
          rowKey="smt_no"
          columns={columns}
          dataSource={data}
          loading={tableLoading}
          size="small"
          scroll={{ x: 900 }}
          onRow={(record) => ({
            onClick: () => setModalSmtNo(record.smt_no),
            style: { cursor: 'pointer' },
          })}
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

      <ShipFormModal
        open={!!modalSmtNo}
        smtNo={modalSmtNo}
        onClose={() => {
          setModalSmtNo(null)
          fetchData()
        }}
      />
    </>
  )
}

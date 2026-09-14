import { useState, useEffect, useCallback } from 'react'
import {
  Card, Table, Button, Space, Input, Form, Row, Col,
  message, Tag, Typography, Tooltip, DatePicker,
} from 'antd'
import { SearchOutlined, PlusOutlined, ReloadOutlined } from '@ant-design/icons'
import dayjs from 'dayjs'
import { acntJournalApi } from '../api/acntJournal'
import JournalFormModal from '../components/JournalFormModal'

const { Title } = Typography
const { RangePicker } = DatePicker

const BILL_TYPE_TAG = {
  0: <Tag>手動</Tag>,
  1: <Tag color="blue">自動過帳</Tag>,
  2: <Tag color="purple">年度結轉</Tag>,
}

function buildSortParam(sorter) {
  const arr = Array.isArray(sorter) ? sorter : sorter ? [sorter] : []
  return arr
    .filter((s) => s.order && s.field)
    .map((s) => `${s.field}:${s.order === 'ascend' ? 'asc' : 'desc'}`)
    .join(',')
}

export default function JournalList() {
  const [form] = Form.useForm()
  const [data, setData] = useState([])
  const [total, setTotal] = useState(0)
  const [page, setPage] = useState(1)
  const [pageSize, setPageSize] = useState(20)
  const [tableLoading, setTableLoading] = useState(false)
  const [searchParams, setSearchParams] = useState({})
  const [sort, setSort] = useState('')
  const [modalJnlNo, setModalJnlNo] = useState(null)

  const fetchData = useCallback(async (params = searchParams, pg = page, ps = pageSize, srt = sort) => {
    setTableLoading(true)
    try {
      const res = await acntJournalApi.list({ ...params, sort: srt || undefined, page: pg, page_size: ps })
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
      date_from: values.date_range?.[0]?.format('YYYY-MM-DD'),
      date_to: values.date_range?.[1]?.format('YYYY-MM-DD'),
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
    { title: '傳票編號', dataIndex: 'jnl_no', key: 'jnl_no', width: 140, sorter: { multiple: 2 } },
    {
      title: '傳票日期', dataIndex: 'jnl_date', key: 'jnl_date', width: 110, sorter: { multiple: 1 }, defaultSortOrder: 'descend',
      render: (v) => dayjs(v).format('YYYY-MM-DD'),
    },
    {
      title: '摘要', dataIndex: 'jnl_desc', key: 'jnl_desc', ellipsis: true, sorter: { multiple: 3 },
      render: (v) => <Tooltip title={v}>{v}</Tooltip>,
    },
    {
      title: '借方合計', dataIndex: 'jnl_debit_total', key: 'jnl_debit_total', width: 110, align: 'right',
      render: (v) => Number(v).toLocaleString(),
    },
    { title: '類型', dataIndex: 'jnl_bill_type', key: 'jnl_bill_type', width: 90, render: (v) => BILL_TYPE_TAG[v] || v },
    { title: '建立人', dataIndex: 'jnl_creator', key: 'jnl_creator', width: 90 },
  ]

  return (
    <>
      <Card styles={{ body: { padding: '12px 24px' } }} style={{ marginBottom: 8 }}>
        <Row justify="space-between" align="middle" gutter={[16, 8]} wrap>
          <Col flex="none">
            <Space direction="vertical" size={0}>
              <Title level={4} style={{ margin: 0 }}>傳票維護</Title>
              <Typography.Text type="secondary">共 <strong>{total}</strong> 筆</Typography.Text>
            </Space>
          </Col>
          <Col flex="auto">
            <Form form={form} layout="inline" onFinish={handleSearch}>
              <Form.Item name="q" label="關鍵字" style={{ marginBottom: 0 }}>
                <Input
                  placeholder="傳票編號 / 摘要"
                  allowClear
                  style={{ width: 220 }}
                  prefix={<SearchOutlined style={{ color: '#bbb' }} />}
                />
              </Form.Item>
              <Form.Item name="date_range" label="日期" style={{ marginBottom: 0 }}>
                <RangePicker />
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
            <Button type="primary" icon={<PlusOutlined />} onClick={() => setModalJnlNo('new')}>
              新增傳票
            </Button>
          </Col>
        </Row>
      </Card>

      <Card styles={{ body: { padding: '8px 16px' } }}>
        <Table
          rowKey="jnl_no"
          columns={columns}
          dataSource={data}
          loading={tableLoading}
          size="small"
          scroll={{ x: 800, y: 'calc(100vh - 400px)' }}
          onRow={(record) => ({
            onClick: () => setModalJnlNo(record.jnl_no),
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

      <JournalFormModal
        open={!!modalJnlNo}
        jnlNo={modalJnlNo}
        onClose={() => {
          setModalJnlNo(null)
          fetchData()
        }}
      />
    </>
  )
}

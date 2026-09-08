import { useState, useEffect, useCallback } from 'react'
import {
  Card, Table, Button, Space, Input, Form, Row, Col, Select, DatePicker,
  message, Tag, Typography, Tooltip, Modal,
} from 'antd'
import { SearchOutlined, PlusOutlined, ReloadOutlined, FilterOutlined } from '@ant-design/icons'
import dayjs from 'dayjs'
import { shipApi } from '../api/ship'
import { customerApi } from '../api/customers'
import { employeeApi } from '../api/employees'
import { productApi } from '../api/products'
import ShipFormModal from '../components/ShipFormModal'
import { SearchSelect } from '../components/SearchSelect'

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

export default function ShipList() {
  const [form] = Form.useForm()
  const [advForm] = Form.useForm()
  const [data, setData] = useState([])
  const [total, setTotal] = useState(0)
  const [page, setPage] = useState(1)
  const [pageSize, setPageSize] = useState(20)
  const [tableLoading, setTableLoading] = useState(false)
  const [searchParams, setSearchParams] = useState({})
  const [sort, setSort] = useState('')
  const [advActive, setAdvActive] = useState(false)
  const [advOpen, setAdvOpen] = useState(false)
  const [modalSmtNo, setModalSmtNo] = useState(null)

  const fetchData = useCallback(async (params = searchParams, pg = page, ps = pageSize, srt = sort) => {
    setTableLoading(true)
    try {
      const res = await shipApi.list({ ...params, sort: srt || undefined, page: pg, page_size: ps })
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
    setAdvActive(false)
    setPage(1)
    fetchData(params, 1, pageSize)
  }

  const handleReset = () => {
    form.resetFields()
    advForm.resetFields()
    setSearchParams({})
    setAdvActive(false)
    setPage(1)
    fetchData({}, 1, pageSize)
  }

  const handleAdvSearch = async () => {
    try {
      const values = await advForm.validateFields()
      const params = {
        date_from: values.date_from?.format('YYYY-MM-DD'),
        date_to: values.date_to?.format('YYYY-MM-DD'),
        smt_no: values.smt_no?.trim() || undefined,
        cum_no: values.cum_no || undefined,
        epy_no: values.epy_no || undefined,
        smt_inv_no: values.smt_inv_no?.trim() || undefined,
        prd_no: values.prd_no || undefined,
      }
      form.resetFields()
      setSearchParams(params)
      setAdvActive(true)
      setAdvOpen(false)
      setPage(1)
      fetchData(params, 1, pageSize)
    } catch {
      // 表單驗證失敗，維持開啟讓使用者修正
    }
  }

  const handleTableChange = (pagination, _filters, sorter) => {
    const srt = buildSortParam(sorter)
    setPage(pagination.current)
    setPageSize(pagination.pageSize)
    setSort(srt)
    fetchData(searchParams, pagination.current, pagination.pageSize, srt)
  }

  const columns = [
    { title: '出貨單號', dataIndex: 'smt_no', key: 'smt_no', width: 130, sorter: { multiple: 2 } },
    {
      title: '客戶', dataIndex: 'cum_name', key: 'cum_name', ellipsis: true, sorter: { multiple: 3 },
      render: (v) => <Tooltip title={v}>{v}</Tooltip>,
    },
    { title: '業務員', dataIndex: 'epy_name', key: 'epy_name', width: 90, sorter: { multiple: 4 } },
    {
      title: '出貨日期', dataIndex: 'smt_date', key: 'smt_date', width: 110, sorter: { multiple: 1 }, defaultSortOrder: 'descend',
      render: (v) => dayjs(v).format('YYYY-MM-DD'),
    },
    { title: '發票號碼', dataIndex: 'smt_inv_no', key: 'smt_inv_no', width: 110, sorter: { multiple: 5 } },
    {
      title: '金額', dataIndex: 'smt_amount', key: 'smt_amount', width: 100, align: 'right', sorter: { multiple: 6 },
      render: (v) => Number(v).toLocaleString(),
    },
    {
      title: '未清帳款', dataIndex: 'smt_not_clean', key: 'smt_not_clean', width: 100, align: 'right', sorter: { multiple: 7 },
      render: (v) => Number(v).toLocaleString(),
    },
    {
      title: '狀態', dataIndex: 'smt_status', key: 'smt_status', width: 90, sorter: { multiple: 8 },
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
              <Button icon={<FilterOutlined />} onClick={() => setAdvOpen(true)}>進階查詢</Button>
              <Button icon={<ReloadOutlined />} onClick={handleReset}>重設</Button>
              {advActive && <Tag closable color="blue" onClose={handleReset}>進階查詢套用中</Tag>}
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

      <Modal
        title="報表查詢"
        open={advOpen}
        onOk={handleAdvSearch}
        onCancel={() => setAdvOpen(false)}
        okText="確定"
        cancelText="取消"
        destroyOnHidden
      >
        <Form form={advForm} layout="vertical" size="small">
          <Row gutter={8}>
            <Col span={12}>
              <Form.Item name="date_from" label="交易日期（起）">
                <DatePicker style={{ width: '100%' }} placeholder="不限制" />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item name="date_to" label="交易日期（迄）">
                <DatePicker style={{ width: '100%' }} placeholder="不限制" />
              </Form.Item>
            </Col>
          </Row>
          <Form.Item name="smt_no" label="憑證編號">
            <Input allowClear placeholder="出貨單號" />
          </Form.Item>
          <Form.Item name="cum_no" label="客戶編號">
            <SearchSelect
              fetcher={(q) => customerApi.list({ q, page_size: 20 })}
              valueField="cum_no"
              labelFn={(c) => `${c.cum_no} ${c.cum_name}`}
              placeholder="搜尋客戶編號/名稱"
            />
          </Form.Item>
          <Form.Item name="epy_no" label="業務員編號">
            <SearchSelect
              fetcher={(q) => employeeApi.list({ q, page_size: 20 })}
              valueField="epy_no"
              labelFn={(e) => `${e.epy_no} ${e.epy_name}`}
              placeholder="搜尋員工編號/姓名"
            />
          </Form.Item>
          <Form.Item name="smt_inv_no" label="發票號碼">
            <Input allowClear />
          </Form.Item>
          <Form.Item name="prd_no" label="產品編號">
            <SearchSelect
              fetcher={(q) => productApi.list({ q, page_size: 20 })}
              valueField="prd_no"
              labelFn={(p) => `${p.prd_no} ${p.prd_name}`}
              placeholder="搜尋產品編號/名稱"
            />
          </Form.Item>
        </Form>
      </Modal>

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

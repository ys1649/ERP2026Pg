import { useState } from 'react'
import { Modal, Input, Table, Space, Button, message } from 'antd'
import { SearchOutlined } from '@ant-design/icons'
import { sysReportApi } from '../api/sysreport'

/**
 * SRF_CONTROLTYPE='SQL' 查詢欄位的挑選視窗：執行該欄位的 SRF_LIST_SQL，
 * 依 SRF_QUERYTYPE 決定單選（Single）或多選（MultiSelect），選取後回傳 SRF_LIST_RETURNFIELD 的值。
 */
export default function SysReportFieldPicker({ srpId, field, value, onChange }) {
  const isMulti = field.srf_querytype === 'MultiSelect'
  const [open, setOpen] = useState(false)
  const [q, setQ] = useState('')
  const [loading, setLoading] = useState(false)
  const [columns, setColumns] = useState([])
  const [returnField, setReturnField] = useState(null)
  const [rows, setRows] = useState([])
  const [selectedKeys, setSelectedKeys] = useState([])
  const [selectedRows, setSelectedRows] = useState([])

  const fetchData = async (query) => {
    setLoading(true)
    try {
      const { data } = await sysReportApi.getFieldLookupData(srpId, field.srf_seqno, query)
      setColumns(data.columns)
      setReturnField(data.return_field)
      setRows(data.rows)
    } catch (err) {
      message.error(err.response?.data?.detail || '查詢失敗')
    } finally {
      setLoading(false)
    }
  }

  const openModal = () => {
    setQ('')
    setSelectedKeys([])
    setSelectedRows([])
    setOpen(true)
    fetchData('')
  }

  const handleOk = () => {
    onChange(isMulti ? selectedRows.map((r) => r[returnField]) : selectedRows[0]?.[returnField])
    setOpen(false)
  }

  const displayText = isMulti ? (Array.isArray(value) ? value.join(', ') : '') : (value ?? '')
  const tableColumns = columns.map((c) => ({ title: c.label, dataIndex: c.key, key: c.key, ellipsis: true }))

  return (
    <>
      <Space.Compact style={{ width: '100%' }}>
        <Input readOnly value={displayText} placeholder={field.srf_dispname} onClick={openModal} />
        <Button icon={<SearchOutlined />} onClick={openModal} />
      </Space.Compact>
      <Modal
        title={field.srf_dispname}
        open={open}
        onOk={handleOk}
        onCancel={() => setOpen(false)}
        okText="確認"
        cancelText="取消"
        width={720}
        destroyOnHidden
      >
        <Input.Search
          placeholder="快速搜尋"
          allowClear
          value={q}
          onChange={(e) => setQ(e.target.value)}
          onSearch={fetchData}
          style={{ marginBottom: 12 }}
        />
        <Table
          rowKey={(r) => (returnField ? r[returnField] : undefined)}
          size="small"
          loading={loading}
          columns={tableColumns}
          dataSource={rows}
          pagination={{ pageSize: 10, showTotal: (t) => `共 ${t} 筆` }}
          scroll={{ y: 320 }}
          rowSelection={{
            type: isMulti ? 'checkbox' : 'radio',
            selectedRowKeys: selectedKeys,
            preserveSelectedRowKeys: true,
            onChange: (keys, sel) => { setSelectedKeys(keys); setSelectedRows(sel) },
          }}
        />
      </Modal>
    </>
  )
}

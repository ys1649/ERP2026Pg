import { useState } from 'react'
import { Card, Form, Input, InputNumber, Button, Space, message, Modal, Table, Tag, Alert, Typography } from 'antd'
import { DatabaseOutlined, CloudSyncOutlined } from '@ant-design/icons'
import { mssqlMigrateApi } from '../api/mssqlMigrate'

const { Text } = Typography

export default function MssqlMigrate() {
  const [form] = Form.useForm()
  const [testing, setTesting] = useState(false)
  const [running, setRunning] = useState(false)
  const [matchedTables, setMatchedTables] = useState(null)
  const [results, setResults] = useState(null)

  const handleTest = async () => {
    const conn = await form.validateFields()
    setTesting(true)
    setResults(null)
    try {
      const { data } = await mssqlMigrateApi.test(conn)
      setMatchedTables(data.matched_tables)
      message.success(`連線成功，MSSQL 共 ${data.mssql_table_count} 張表，其中 ${data.matched_tables.length} 張跟 PostgreSQL 同名可搬移`)
    } catch (err) {
      setMatchedTables(null)
      message.error(err.response?.data?.detail || '連線失敗')
    } finally {
      setTesting(false)
    }
  }

  const doRun = async (conn) => {
    setRunning(true)
    setResults(null)
    try {
      const { data } = await mssqlMigrateApi.run(conn)
      setResults(data.tables)
      message.success(data.message)
    } catch (err) {
      message.error(err.response?.data?.detail || '搬移失敗')
    } finally {
      setRunning(false)
    }
  }

  const handleRun = async () => {
    const conn = await form.validateFields()
    Modal.confirm({
      title: '確定要開始搬移嗎？',
      content: (
        <>
          <p>這會把 PostgreSQL 裡跟 MSSQL 同名的資料表<Text strong>先清空（TRUNCATE）</Text>，再從 MSSQL 全量複製過去。</p>
          <p>PostgreSQL 現有資料將會被覆蓋，此動作無法復原，請確認來源資料庫正確。</p>
        </>
      ),
      okText: '確定搬移',
      okButtonProps: { danger: true },
      cancelText: '取消',
      onOk: () => doRun(conn),
    })
  }

  const columns = [
    { title: '資料表', dataIndex: 'table', key: 'table' },
    { title: '筆數', dataIndex: 'rows', key: 'rows', width: 100 },
    { title: '備註', dataIndex: 'note', key: 'note', render: (v) => v && <Tag color="warning">{v}</Tag> },
  ]

  return (
    <Space direction="vertical" size="large" style={{ width: '100%' }}>
      <Card title={<><DatabaseOutlined /> MSSQL 資料轉入 PostgreSQL</>}>
        <Alert
          type="info"
          showIcon
          style={{ marginBottom: 16 }}
          message="用途"
          description="把舊系統（Delphi6ERP／MSSQL）的資料，搬到本系統現在使用的 PostgreSQL 資料庫。PostgreSQL 這邊的連線固定使用系統設定，只需要填來源 MSSQL 的連線資訊。目標資料表結構須已事先建立好（例如用 PowerDesigner），此功能只搬資料，不會建立或修改資料表結構；只會處理跟 PostgreSQL 同名的資料表，且不會動系統報表引擎自己的 4 張表。"
        />
        <Form form={form} layout="vertical" initialValues={{ port: 1433 }}>
          <Space.Compact block>
            <Form.Item name="server" label="伺服器" rules={[{ required: true, message: '必填' }]} style={{ width: '60%' }}>
              <Input placeholder="例：tnvtrsap01 或 192.168.1.10" />
            </Form.Item>
            <Form.Item name="port" label="連接埠" style={{ width: '40%' }}>
              <InputNumber style={{ width: '100%' }} placeholder="1433" />
            </Form.Item>
          </Space.Compact>
          <Form.Item name="database" label="資料庫名稱" rules={[{ required: true, message: '必填' }]}>
            <Input placeholder="例：erp" />
          </Form.Item>
          <Space.Compact block>
            <Form.Item name="user" label="使用者帳號" rules={[{ required: true, message: '必填' }]} style={{ width: '50%' }}>
              <Input />
            </Form.Item>
            <Form.Item name="password" label="密碼" rules={[{ required: true, message: '必填' }]} style={{ width: '50%' }}>
              <Input.Password />
            </Form.Item>
          </Space.Compact>

          <Space>
            <Button onClick={handleTest} loading={testing}>測試連線</Button>
            <Button type="primary" danger icon={<CloudSyncOutlined />} onClick={handleRun} loading={running}>
              開始搬移
            </Button>
          </Space>
        </Form>

        {matchedTables && (
          <Alert
            style={{ marginTop: 16 }}
            type="success"
            message={`可搬移 ${matchedTables.length} 張表`}
            description={matchedTables.join('、')}
          />
        )}
      </Card>

      {results && (
        <Card title="搬移結果">
          <Table
            rowKey="table"
            size="small"
            columns={columns}
            dataSource={results}
            pagination={false}
          />
        </Card>
      )}
    </Space>
  )
}

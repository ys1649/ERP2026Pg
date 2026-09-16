import { useState } from 'react'
import { Card, Button, Space, message, Modal, Alert, Upload, Input, Typography } from 'antd'
import { CloudDownloadOutlined, CloudUploadOutlined, InboxOutlined } from '@ant-design/icons'
import { reportBackupApi } from '../api/reportBackup'

const { Text } = Typography
const { Dragger } = Upload

const CONFIRM_TEXT = '確認還原'

export default function ReportBackup() {
  const [exporting, setExporting] = useState(false)
  const [restoring, setRestoring] = useState(false)
  const [file, setFile] = useState(null)
  const [confirmOpen, setConfirmOpen] = useState(false)
  const [confirmInput, setConfirmInput] = useState('')

  const handleExport = async () => {
    setExporting(true)
    try {
      const res = await reportBackupApi.export()
      const disposition = res.headers['content-disposition'] || ''
      const match = disposition.match(/filename="?([^";]+)"?/)
      const filename = match ? match[1] : `SYSREPORT${Date.now()}.sql`

      const url = URL.createObjectURL(new Blob([res.data], { type: 'application/sql' }))
      const a = document.createElement('a')
      a.href = url
      a.download = filename
      document.body.appendChild(a)
      a.click()
      a.remove()
      URL.revokeObjectURL(url)
      message.success('備份檔案已下載')
    } catch (err) {
      message.error('備份失敗')
    } finally {
      setExporting(false)
    }
  }

  const openConfirm = () => {
    if (!file) {
      message.warning('請先選擇備份檔案')
      return
    }
    setConfirmInput('')
    setConfirmOpen(true)
  }

  const handleRestore = async () => {
    setConfirmOpen(false)
    setRestoring(true)
    try {
      const { data } = await reportBackupApi.restore(file)
      message.success(`${data.message}（還原前安全備份：${data.safety_backup}）`)
      setFile(null)
    } catch (err) {
      message.error(err.response?.data?.detail || '還原失敗')
    } finally {
      setRestoring(false)
    }
  }

  return (
    <Space direction="vertical" size="large" style={{ width: '100%' }}>
      <Card title="報表資料備份">
        <Alert
          type="info"
          showIcon
          style={{ marginBottom: 16 }}
          message="用途"
          description="將系統報表相關 4 張表（TBLSYSREPORT／TBLSYSREPORTFIELD／TBLDD／TBL_DDFIELD）的結構與內容，匯出成單一 .sql 檔案下載。"
        />
        <Button type="primary" icon={<CloudDownloadOutlined />} onClick={handleExport} loading={exporting}>
          立即備份
        </Button>
      </Card>

      <Card title="報表資料還原">
        <Alert
          type="warning"
          showIcon
          style={{ marginBottom: 16 }}
          message="注意"
          description="還原會清除並重建 TBLSYSREPORT／TBLSYSREPORTFIELD／TBLDD／TBL_DDFIELD 這 4 張表，以備份檔案的內容完全覆蓋現有資料，此動作無法復原（系統會在還原前自動於伺服器保留一份安全備份）。"
        />
        <Dragger
          accept=".sql"
          maxCount={1}
          fileList={file ? [file] : []}
          beforeUpload={(f) => {
            setFile(f)
            return false
          }}
          onRemove={() => setFile(null)}
        >
          <p className="ant-upload-drag-icon"><InboxOutlined /></p>
          <p className="ant-upload-text">點擊或拖曳備份檔案到此處</p>
        </Dragger>
        <Button
          danger
          type="primary"
          icon={<CloudUploadOutlined />}
          style={{ marginTop: 16 }}
          onClick={openConfirm}
          loading={restoring}
        >
          開始還原
        </Button>
      </Card>

      <Modal
        title="確定要還原報表資料嗎？"
        open={confirmOpen}
        onCancel={() => setConfirmOpen(false)}
        onOk={handleRestore}
        okText="確定還原"
        okButtonProps={{ danger: true, disabled: confirmInput !== CONFIRM_TEXT }}
        cancelText="取消"
      >
        <p>此動作會<Text strong>清除並覆蓋</Text> TBLSYSREPORT／TBLSYSREPORTFIELD／TBLDD／TBL_DDFIELD 這 4 張表，且無法復原。</p>
        <p>請輸入「{CONFIRM_TEXT}」以確認：</p>
        <Input value={confirmInput} onChange={(e) => setConfirmInput(e.target.value)} placeholder={CONFIRM_TEXT} />
      </Modal>
    </Space>
  )
}

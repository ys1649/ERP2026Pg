import { useEffect } from 'react'
import { Modal, Form, Input } from 'antd'

export default function SysReportCopyModal({ open, record, onOk, onCancel, loading }) {
  const [form] = Form.useForm()

  useEffect(() => {
    if (!open || !record) return
    form.setFieldsValue({
      srp_code: `${record.srp_code}_COPY`,
      srp_name: `${record.srp_name} 複製`,
    })
  }, [open, record, form])

  const handleOk = () => {
    form.validateFields().then((values) => onOk(values))
  }

  return (
    <Modal
      title={`複製系統報表 — ${record?.srp_code ?? ''}`}
      open={open}
      onOk={handleOk}
      onCancel={onCancel}
      okText="複製"
      cancelText="取消"
      confirmLoading={loading}
      destroyOnHidden
    >
      <Form form={form} layout="vertical" size="small">
        <Form.Item name="srp_code" label="新報表編號" rules={[{ required: true, message: '必填' }]}>
          <Input maxLength={20} />
        </Form.Item>
        <Form.Item name="srp_name" label="新報表名稱" rules={[{ required: true, message: '必填' }]}>
          <Input maxLength={80} />
        </Form.Item>
      </Form>
    </Modal>
  )
}

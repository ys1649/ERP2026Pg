import { useEffect } from 'react'
import { Modal, Form, Input, Divider, Row, Col, Checkbox } from 'antd'

const { TextArea } = Input

export default function EmployeeFormModal({ open, record, onOk, onCancel, loading }) {
  const [form] = Form.useForm()
  const isEdit = !!record

  useEffect(() => {
    if (!open) return
    form.resetFields()
    form.setFieldsValue(
      record
        ? { ...record, epy_password2: record.epy_password }
        : { epy_is_can_login: true }
    )
  }, [open, record, form])

  const handleOk = () => {
    form.validateFields().then(({ epy_password2, ...values }) => {
      onOk(values)
    })
  }

  return (
    <Modal
      title={isEdit ? `編輯員工 — ${record?.epy_no}` : '新增員工'}
      open={open}
      onOk={handleOk}
      onCancel={onCancel}
      okText={isEdit ? '儲存' : '新增'}
      cancelText="取消"
      confirmLoading={loading}
      width={600}
      destroyOnHidden
    >
      <Form form={form} layout="vertical" size="small">
        <Divider titlePlacement="left" plain>基本資料</Divider>
        <Row gutter={16}>
          <Col span={12}>
            <Form.Item name="epy_no" label="員工編號" rules={[{ required: true, message: '必填' }]}>
              <Input disabled={isEdit} placeholder="例：E001" maxLength={20} />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item name="epy_name" label="員工姓名" rules={[{ required: true, message: '必填' }]}>
              <Input maxLength={20} />
            </Form.Item>
          </Col>
        </Row>
        <Row gutter={16}>
          <Col span={12}>
            <Form.Item name="epy_password" label="登入密碼">
              <Input.Password maxLength={20} autoComplete="new-password" />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              name="epy_password2"
              label="確認密碼"
              dependencies={['epy_password']}
              rules={[
                {
                  validator(_, value) {
                    if (value === form.getFieldValue('epy_password')) return Promise.resolve()
                    return Promise.reject(new Error('密碼輸入不一致'))
                  },
                },
              ]}
            >
              <Input.Password maxLength={20} autoComplete="new-password" />
            </Form.Item>
          </Col>
        </Row>
        <Form.Item name="epy_is_can_login" valuePropName="checked">
          <Checkbox>允許登入系統</Checkbox>
        </Form.Item>

        <Divider titlePlacement="left" plain>聯絡資料</Divider>
        <Row gutter={16}>
          <Col span={12}>
            <Form.Item name="epy_tel1" label="電話1">
              <Input maxLength={30} />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item name="epy_tel2" label="電話2">
              <Input maxLength={30} />
            </Form.Item>
          </Col>
        </Row>
        <Form.Item name="epy_addr" label="地址">
          <Input maxLength={200} />
        </Form.Item>

        <Form.Item name="epy_desc" label="說明">
          <TextArea rows={2} maxLength={200} showCount />
        </Form.Item>
      </Form>
    </Modal>
  )
}

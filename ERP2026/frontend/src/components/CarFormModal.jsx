import { useEffect } from 'react'
import { Modal, Form, Input, DatePicker, Divider, Row, Col } from 'antd'
import dayjs from 'dayjs'

const { TextArea } = Input

export default function CarFormModal({ open, record, onOk, onCancel, loading }) {
  const [form] = Form.useForm()
  const isEdit = !!record

  useEffect(() => {
    if (!open) return
    form.resetFields()
    if (record) {
      form.setFieldsValue({ ...record, car_date1: record.car_date1 ? dayjs(record.car_date1) : null })
    }
  }, [open, record, form])

  const handleOk = () => {
    form.validateFields().then((values) => {
      onOk({
        ...values,
        car_date1: values.car_date1 ? values.car_date1.format('YYYY-MM-DD') : null,
      })
    })
  }

  return (
    <Modal
      title={isEdit ? `編輯車輛 — ${record?.car_no}` : '新增車輛'}
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
            <Form.Item name="car_no" label="車輛編號" rules={[{ required: true, message: '必填' }]}>
              <Input disabled={isEdit} placeholder="例：CAR001" maxLength={20} />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item name="car_brand" label="廠牌型式">
              <Input maxLength={80} />
            </Form.Item>
          </Col>
        </Row>
        <Row gutter={16}>
          <Col span={12}>
            <Form.Item name="car_license_no" label="車牌號碼">
              <Input maxLength={80} />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item name="car_date1" label="出廠/監理日期">
              <DatePicker style={{ width: '100%' }} />
            </Form.Item>
          </Col>
        </Row>
        <Form.Item name="car_desc" label="說明">
          <TextArea rows={2} maxLength={200} showCount />
        </Form.Item>
      </Form>
    </Modal>
  )
}

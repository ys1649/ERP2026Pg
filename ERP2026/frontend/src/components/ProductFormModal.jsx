import { useEffect } from 'react'
import { Modal, Form, Input, InputNumber, Divider, Row, Col, Checkbox } from 'antd'

const { TextArea } = Input

export default function ProductFormModal({ open, record, onOk, onCancel, loading }) {
  const [form] = Form.useForm()
  const isEdit = !!record

  useEffect(() => {
    if (!open) return
    form.resetFields()
    form.setFieldsValue(
      record
        ? { ...record }
        : { prd_sale_price: 0, prd_safe_qty: 0, prd_is_dummy: false, prd_dum_cost_rate: 0, prd_ext_cost_ratio: 0.1 }
    )
  }, [open, record, form])

  const handleOk = () => {
    form.validateFields().then((values) => {
      onOk(values)
    })
  }

  return (
    <Modal
      title={isEdit ? `編輯產品 — ${record?.prd_no}` : '新增產品'}
      open={open}
      onOk={handleOk}
      onCancel={onCancel}
      okText={isEdit ? '儲存' : '新增'}
      cancelText="取消"
      confirmLoading={loading}
      width={700}
      destroyOnHidden
    >
      <Form form={form} layout="vertical" size="small">
        <Divider titlePlacement="left" plain>基本資料</Divider>
        <Row gutter={16}>
          <Col span={8}>
            <Form.Item name="prd_no" label="產品編號" rules={[{ required: true, message: '必填' }]}>
              <Input disabled={isEdit} placeholder="例：P001" maxLength={20} />
            </Form.Item>
          </Col>
          <Col span={16}>
            <Form.Item name="prd_name" label="產品名稱" rules={[{ required: true, message: '必填' }]}>
              <Input placeholder="產品全名" maxLength={80} />
            </Form.Item>
          </Col>
        </Row>
        <Row gutter={16}>
          <Col span={8}>
            <Form.Item name="prd_unit" label="單位">
              <Input maxLength={6} />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item name="prd_sale_price" label="售價">
              <InputNumber min={0} step={1} style={{ width: '100%' }} />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item name="prd_safe_qty" label="安全存量">
              <InputNumber min={0} step={1} style={{ width: '100%' }} />
            </Form.Item>
          </Col>
        </Row>

        {isEdit && (
          <>
            <Divider titlePlacement="left" plain>庫存資料（系統自動維護，不可編輯）</Divider>
            <Row gutter={16}>
              <Col span={12}>
                <Form.Item label="現有庫存量">
                  <InputNumber disabled value={record?.prd_onhand} style={{ width: '100%' }} />
                </Form.Item>
              </Col>
              <Col span={12}>
                <Form.Item label="現行平均成本">
                  <InputNumber disabled value={record?.prd_cur_cost} style={{ width: '100%' }} />
                </Form.Item>
              </Col>
            </Row>
          </>
        )}

        <Divider titlePlacement="left" plain>成本設定</Divider>
        <Row gutter={16} align="middle">
          <Col span={6}>
            <Form.Item name="prd_is_dummy" valuePropName="checked" label=" ">
              <Checkbox>虛擬品項</Checkbox>
            </Form.Item>
          </Col>
          <Col span={9}>
            <Form.Item name="prd_dum_cost_rate" label="虛擬成本比率">
              <InputNumber min={0} max={1} step={0.01} style={{ width: '100%' }}
                formatter={(v) => `${(v * 100).toFixed(0)}%`}
                parser={(v) => parseFloat(v.replace('%', '')) / 100}
              />
            </Form.Item>
          </Col>
          <Col span={9}>
            <Form.Item name="prd_ext_cost_ratio" label="外加成本比率">
              <InputNumber min={0} max={1} step={0.01} style={{ width: '100%' }}
                formatter={(v) => `${(v * 100).toFixed(0)}%`}
                parser={(v) => parseFloat(v.replace('%', '')) / 100}
              />
            </Form.Item>
          </Col>
        </Row>

        <Form.Item name="prd_desc" label="說明">
          <TextArea rows={2} maxLength={200} showCount />
        </Form.Item>
      </Form>
    </Modal>
  )
}

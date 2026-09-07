import { useEffect } from 'react'
import { Modal, Form, Input, InputNumber, Divider, Row, Col } from 'antd'

const { TextArea } = Input

export default function SupplierFormModal({ open, record, onOk, onCancel, loading }) {
  const [form] = Form.useForm()
  const isEdit = !!record

  useEffect(() => {
    if (!open) return
    form.resetFields()
    form.setFieldsValue(
      record
        ? { ...record }
        : { sup_acnt_ap: '2141', sup_acnt_advance: '1261', sup_advance_amount: 0 }
    )
  }, [open, record, form])

  const handleOk = () => {
    form.validateFields().then((values) => {
      onOk(values)
    })
  }

  return (
    <Modal
      title={isEdit ? `編輯廠商 — ${record?.sup_no}` : '新增廠商'}
      open={open}
      onOk={handleOk}
      onCancel={onCancel}
      okText={isEdit ? '儲存' : '新增'}
      cancelText="取消"
      confirmLoading={loading}
      width={800}
      destroyOnHidden
    >
      <Form form={form} layout="vertical" size="small">
        {/* ── 基本資料 ── */}
        <Divider titlePlacement="left" plain>基本資料</Divider>
        <Row gutter={16}>
          <Col span={8}>
            <Form.Item name="sup_no" label="廠商編號" rules={[{ required: true, message: '必填' }]}>
              <Input disabled={isEdit} placeholder="例：S001" maxLength={20} />
            </Form.Item>
          </Col>
          <Col span={16}>
            <Form.Item name="sup_name" label="廠商名稱" rules={[{ required: true, message: '必填' }]}>
              <Input placeholder="公司全名" maxLength={80} />
            </Form.Item>
          </Col>
        </Row>
        <Row gutter={16}>
          <Col span={8}>
            <Form.Item name="sup_president" label="負責人">
              <Input maxLength={20} />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item name="sup_uniform_no" label="統一編號">
              <Input maxLength={20} />
            </Form.Item>
          </Col>
        </Row>

        {/* ── 聯絡資料 ── */}
        <Divider titlePlacement="left" plain>聯絡資料</Divider>
        <Row gutter={16}>
          <Col span={8}>
            <Form.Item name="sup_contant" label="聯絡人">
              <Input maxLength={20} />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item name="sup_cont_title" label="聯絡人職稱">
              <Input maxLength={20} />
            </Form.Item>
          </Col>
        </Row>
        <Row gutter={16}>
          <Col span={8}>
            <Form.Item name="sup_tel1" label="電話1">
              <Input maxLength={30} />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item name="sup_tel2" label="電話2">
              <Input maxLength={30} />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item name="sup_fax" label="傳真">
              <Input maxLength={30} />
            </Form.Item>
          </Col>
        </Row>
        <Row gutter={16}>
          <Col span={6}>
            <Form.Item name="sup_zip_code" label="郵遞區號">
              <Input maxLength={6} />
            </Form.Item>
          </Col>
          <Col span={18}>
            <Form.Item name="sup_addr" label="公司地址">
              <Input maxLength={200} />
            </Form.Item>
          </Col>
        </Row>
        <Form.Item name="sup_inv_addr" label="發票地址">
          <Input maxLength={200} />
        </Form.Item>

        {/* ── 財務資料 ── */}
        <Divider titlePlacement="left" plain>財務資料</Divider>
        <Row gutter={16}>
          <Col span={8}>
            <Form.Item name="sup_acnt_ap" label="應付帳款科目">
              <Input maxLength={20} />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item name="sup_acnt_advance" label="預付帳款科目">
              <Input maxLength={20} />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item name="sup_advance_amount" label="預付款餘額">
              <InputNumber min={0} step={1000} style={{ width: '100%' }}
                formatter={(v) => `$ ${v}`.replace(/\B(?=(\d{3})+(?!\d))/g, ',')}
                parser={(v) => v.replace(/\$\s?|(,*)/g, '')}
              />
            </Form.Item>
          </Col>
        </Row>

        {/* ── 說明 ── */}
        <Form.Item name="sup_desc" label="說明">
          <TextArea rows={2} maxLength={200} showCount />
        </Form.Item>
      </Form>
    </Modal>
  )
}

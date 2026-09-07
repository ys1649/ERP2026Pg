import { useEffect, useState } from 'react'
import { Modal, Form, Input, Select, Checkbox, Divider, Row, Col } from 'antd'
import { acntAccountApi } from '../api/acntAccounts'

const { TextArea } = Input

const ACT_NO_RULE = {
  pattern: /^\d{4}$|^\d{4}\.\d{4}$/,
  message: '科目編號須為 4 碼數字（如 1111）或 9 碼「4碼.4碼」（如 1111.0001）',
}

export default function AcntAccountFormModal({ open, record, onOk, onCancel, loading }) {
  const [form] = Form.useForm()
  const [types, setTypes] = useState([])
  const isEdit = !!record

  useEffect(() => {
    if (!open) return
    acntAccountApi.listTypes().then((res) => setTypes(res.data)).catch(() => setTypes([]))
    form.resetFields()
    form.setFieldsValue(
      record ? { ...record } : { act_category_reverse: false, act_category_cash: false }
    )
  }, [open, record, form])

  const handleOk = () => {
    form.validateFields().then((values) => {
      onOk(values)
    })
  }

  return (
    <Modal
      title={isEdit ? `編輯會計科目 — ${record?.act_no}` : '新增會計科目'}
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
            <Form.Item
              name="act_no"
              label="科目編號"
              rules={[{ required: true, message: '必填' }, ACT_NO_RULE]}
            >
              <Input disabled={isEdit} placeholder="例：1111 或 1111.0001" maxLength={20} />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item name="typ_no" label="科目類別" rules={[{ required: true, message: '必填' }]}>
              <Select
                showSearch
                placeholder="請選擇科目類別"
                optionFilterProp="label"
                options={types.map((t) => ({ value: t.typ_no, label: `${t.typ_no} ${t.typ_name}` }))}
              />
            </Form.Item>
          </Col>
        </Row>
        <Form.Item name="act_name" label="科目名稱" rules={[{ required: true, message: '必填' }]}>
          <Input maxLength={80} />
        </Form.Item>
        <Row gutter={16}>
          <Col span={12}>
            <Form.Item name="act_category_reverse" valuePropName="checked">
              <Checkbox>科目性質為反轉（借貸相反）</Checkbox>
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item name="act_category_cash" valuePropName="checked">
              <Checkbox>屬於現金科目</Checkbox>
            </Form.Item>
          </Col>
        </Row>
        <Form.Item name="act_desc" label="說明">
          <TextArea rows={2} maxLength={200} showCount />
        </Form.Item>
      </Form>
    </Modal>
  )
}

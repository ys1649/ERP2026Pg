import { useEffect } from 'react'
import { Modal, Form, Input } from 'antd'

const { TextArea } = Input

export default function SysReportFormModal({ open, record, onOk, onCancel, loading }) {
  const [form] = Form.useForm()
  const isEdit = !!record

  useEffect(() => {
    if (!open) return
    form.setFieldsValue(record ? { ...record } : {})
  }, [open, record, form])

  const handleOk = () => {
    form.validateFields().then((values) => onOk(values))
  }

  return (
    <Modal
      title={isEdit ? `編輯系統報表 — ${record?.srp_code}` : '新增系統報表'}
      open={open}
      onOk={handleOk}
      onCancel={onCancel}
      okText={isEdit ? '儲存' : '新增'}
      cancelText="取消"
      confirmLoading={loading}
      width={760}
      destroyOnHidden
    >
      <Form form={form} layout="vertical" size="small">
        <Form.Item name="srp_code" label="報表編號" rules={[{ required: true, message: '必填' }]}>
          <Input maxLength={20} placeholder="例：FM_CUM_001" />
        </Form.Item>
        <Form.Item name="srp_name" label="報表名稱" rules={[{ required: true, message: '必填' }]}>
          <Input maxLength={80} placeholder="例：客戶編號速查表" />
        </Form.Item>
        <Form.Item name="srp_description" label="報表說明">
          <Input maxLength={255} />
        </Form.Item>
        <Form.Item
          name="srp_select"
          label="SRP_SELECT（主要查詢 SQL）"
          rules={[{ required: true, message: '必填' }]}
          extra="單一 SELECT 查詢，查詢欄位所在的資料表要給別名，例：SELECT A.* FROM TBL_CUSTOMER A"
        >
          <TextArea rows={4} style={{ fontFamily: 'monospace' }} />
        </Form.Item>
        <Form.Item
          name="srp_where"
          label="SRP_WHERE（固定條件，選填）"
          extra="要包含 WHERE 關鍵字本身，例：WHERE A.CUM_NO &lt;&gt; '0000'；查詢欄位的條件會自動用 AND 接在後面"
        >
          <TextArea rows={2} style={{ fontFamily: 'monospace' }} />
        </Form.Item>
        <Form.Item
          name="srp_groupby"
          label="SRP_GROUPBY（選填）"
          extra="要包含 GROUP BY 關鍵字本身，例：GROUP BY A.CUM_NO"
        >
          <TextArea rows={2} style={{ fontFamily: 'monospace' }} />
        </Form.Item>
        <Form.Item
          name="srp_orderby"
          label="SRP_ORDERBY（預設排序，選填）"
          extra="要包含 ORDER BY 關鍵字本身，例：ORDER BY A.CUM_NO；查詢欄位裡標記排序的欄位會自動接在後面"
        >
          <TextArea rows={2} style={{ fontFamily: 'monospace' }} />
        </Form.Item>
      </Form>
    </Modal>
  )
}

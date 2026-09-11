import { useEffect, useState } from 'react'
import { Modal, Form, Input, InputNumber, Select, Radio, Button, Space, message } from 'antd'
import { SearchOutlined } from '@ant-design/icons'
import { sysReportApi } from '../api/sysreport'

const CONTROL_TYPES = [
  { label: 'Edit（文字/數字輸入框）', value: 'Edit' },
  { label: 'Date（日期選擇器）', value: 'Date' },
  { label: 'ListItem（下拉選單，固定選項）', value: 'ListItem' },
  { label: 'SQL（彈窗挑選，資料來自 SQL）', value: 'SQL' },
]

const QUERY_TYPES = [
  { label: 'Single（單一值）', value: 'Single' },
  { label: 'Range（起迄範圍）', value: 'Range' },
  { label: 'MultiSelect（多選，僅限 SQL 控制項）', value: 'MultiSelect' },
]

const DATA_TYPES = [
  { label: 'String', value: 'String' },
  { label: 'Numberic', value: 'Numberic' },
  { label: 'Date', value: 'Date' },
]

export default function SysReportFieldFormModal({ open, srpId, record, onOk, onCancel, loading }) {
  const [form] = Form.useForm()
  const isEdit = !!record
  const controlType = Form.useWatch('srf_controltype', form)
  const queryType = Form.useWatch('srf_querytype', form)
  const [columnOptions, setColumnOptions] = useState([])
  const [columnsLoading, setColumnsLoading] = useState(false)

  useEffect(() => {
    if (!open) return
    form.setFieldsValue(
      record
        ? { ...record }
        : {
            srf_datatype: 'String', srf_controltype: 'Edit', srf_querytype: 'Single',
            srf_disporder: 0, srf_ismustcriteria: false, srf_iswhere: true,
            srf_issort: false, srf_sortdec: false,
          }
    )
  }, [open, record, form])

  useEffect(() => {
    if (queryType === 'MultiSelect' && controlType !== 'SQL') {
      form.setFieldValue('srf_controltype', 'SQL')
    }
  }, [queryType, controlType, form])

  const loadColumns = async () => {
    setColumnsLoading(true)
    try {
      const { data } = await sysReportApi.getSelectColumns(srpId)
      setColumnOptions(data.map((c) => ({ label: `${c.field_name}（${c.datatype}）`, value: c.field_name, datatype: c.datatype })))
    } catch (err) {
      message.error(err.response?.data?.detail || 'SRP_SELECT 執行失敗，無法列出欄位')
    } finally {
      setColumnsLoading(false)
    }
  }

  const handlePickColumn = (fieldName) => {
    const opt = columnOptions.find((o) => o.value === fieldName)
    form.setFieldValue('srf_fieldname', fieldName)
    if (opt) form.setFieldValue('srf_datatype', opt.datatype)
  }

  const handleOk = () => {
    form.validateFields().then((values) => onOk(values))
  }

  return (
    <Modal
      title={isEdit ? `編輯查詢欄位 — ${record?.srf_fieldname}` : '新增查詢欄位'}
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
        <Form.Item label="從 SRP_SELECT 選欄位">
          <Select
            showSearch
            placeholder="點選展開後會執行 SRP_SELECT 列出真正可選的欄位"
            loading={columnsLoading}
            options={columnOptions}
            onFocus={() => { if (columnOptions.length === 0) loadColumns() }}
            onChange={handlePickColumn}
            suffixIcon={<SearchOutlined />}
          />
        </Form.Item>
        <Form.Item
          name="srf_fieldname"
          label="SRF_FIELDNAME（欄位名稱）"
          rules={[{ required: true, message: '必填' }]}
          extra="也可以直接手動輸入，不一定要用上面的選欄位"
        >
          <Input maxLength={80} placeholder="例：CUM_NO" />
        </Form.Item>
        <Form.Item
          name="srf_tablealias"
          label="SRF_TABLEALIAS（資料表別名）"
          extra="要跟 SRP_SELECT 裡的別名一致，例：SELECT A.* FROM TBL_CUSTOMER A 這裡就填 A；留空則直接用欄位名稱，不加別名前綴"
        >
          <Input maxLength={80} placeholder="例：A" />
        </Form.Item>
        <Form.Item name="srf_dispname" label="SRF_DISPNAME（顯示名稱）" rules={[{ required: true, message: '必填' }]}>
          <Input maxLength={80} placeholder="例：客戶編號" />
        </Form.Item>
        <Form.Item name="srf_datatype" label="SRF_DATATYPE" rules={[{ required: true, message: '必填' }]}>
          <Select options={DATA_TYPES} />
        </Form.Item>
        <Form.Item name="srf_controltype" label="SRF_CONTROLTYPE" rules={[{ required: true, message: '必填' }]}>
          <Select options={CONTROL_TYPES} disabled={queryType === 'MultiSelect'} />
        </Form.Item>
        <Form.Item name="srf_querytype" label="SRF_QUERYTYPE" rules={[{ required: true, message: '必填' }]}>
          <Select options={QUERY_TYPES} />
        </Form.Item>

        {controlType === 'ListItem' && (
          <Form.Item
            name="srf_list_value"
            label="SRF_LIST_VALUE（選項列表）"
            rules={[{ required: true, message: '必填' }]}
            extra="以逗號分隔選項內容，例：北區,中區,南區"
          >
            <Input maxLength={4000} />
          </Form.Item>
        )}

        {controlType === 'SQL' && (
          <>
            <Form.Item
              name="srf_list_sql"
              label="SRF_LIST_SQL（挑選視窗資料來源）"
              rules={[{ required: true, message: '必填' }]}
              extra="單一 SELECT 查詢，回傳的每個欄位會顯示成挑選視窗裡的一欄"
            >
              <Input.TextArea rows={2} maxLength={4000} style={{ fontFamily: 'monospace' }} placeholder="例：SELECT CUM_NO,CUM_NAME FROM TBL_CUSTOMER" />
            </Form.Item>
            <Form.Item
              name="srf_list_returnfield"
              label="SRF_LIST_RETURNFIELD（回傳欄位）"
              rules={[{ required: true, message: '必填' }]}
              extra="使用者選取後，實際拿去下查詢條件的欄位名稱，需對應 SRF_LIST_SQL 選出的欄位"
            >
              <Input maxLength={80} placeholder="例：CUM_NO" />
            </Form.Item>
            <Form.Item
              name="srf_list_fielddisp"
              label="SRF_LIST_FIELDDISP（欄位顯示標題）"
              rules={[{ required: true, message: '必填' }]}
              extra="逗號分隔，順序需對應 SRF_LIST_SQL 選出的欄位，例：客戶編號,客戶名稱"
            >
              <Input maxLength={4000} />
            </Form.Item>
          </>
        )}

        <Form.Item name="srf_ismustcriteria" label="SRF_ISMUSTCRITERIA（是否為必要條件）">
          <Radio.Group options={[{ label: '是', value: true }, { label: '否', value: false }]} />
        </Form.Item>
        <Form.Item name="srf_iswhere" label="SRF_ISWHERE（是否出現在查詢條件畫面）">
          <Radio.Group options={[{ label: '是', value: true }, { label: '否', value: false }]} />
        </Form.Item>
        <Space.Compact block>
          <Form.Item name="srf_issort" label="SRF_ISSORT（是否可排序）" style={{ width: '50%' }}>
            <Radio.Group options={[{ label: '是', value: true }, { label: '否', value: false }]} />
          </Form.Item>
          <Form.Item name="srf_sortdec" label="SRF_SORTDEC（預設遞減）" style={{ width: '50%' }}>
            <Radio.Group options={[{ label: '是', value: true }, { label: '否', value: false }]} />
          </Form.Item>
        </Space.Compact>
        <Form.Item name="srf_disporder" label="SRF_DISPORDER（顯示/排序順序）" rules={[{ required: true, message: '必填' }]}>
          <InputNumber min={0} style={{ width: '100%' }} />
        </Form.Item>
      </Form>
    </Modal>
  )
}

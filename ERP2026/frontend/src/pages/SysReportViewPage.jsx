import { useEffect, useRef, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { Card, Button, message } from 'antd'
import { ArrowLeftOutlined, SearchOutlined } from '@ant-design/icons'
import { sysReportApi } from '../api/sysreport'
import SysReportQuery from '../components/SysReportQuery'

// 首頁「表單/管理/統計報表模組」點進來的共用檢視頁面，srpId 從路由帶進來，
// 查詢條件、排序、預覽都直接複用系統報表定義那邊「測試」用的 SysReportQuery。
export default function SysReportViewPage() {
  const { srpId: srpIdParam } = useParams()
  const srpId = Number(srpIdParam)
  const navigate = useNavigate()
  const [report, setReport] = useState(null)
  const queryRef = useRef(null)

  useEffect(() => {
    sysReportApi.get(srpId).then((res) => setReport(res.data)).catch(() => message.error('載入報表資料失敗'))
  }, [srpId])

  return (
    <Card
      title={
        <span>
          <Button
            type="text"
            icon={<ArrowLeftOutlined />}
            onClick={() => navigate('/')}
            style={{ marginRight: 8 }}
          />
          {report?.srp_name ?? ''}（{report?.srp_code ?? ''}）
        </span>
      }
      extra={
        <Button type="primary" icon={<SearchOutlined />} onClick={() => queryRef.current?.preview()}>
          預覽
        </Button>
      }
    >
      {srpId ? <SysReportQuery ref={queryRef} srpId={srpId} /> : null}
    </Card>
  )
}

import { Typography } from 'antd'
import './Home.css'

// 導覽已經改由 MainLayout 的頂端選單／快速操作工具列負責（比照舊 Delphi 主畫面），
// 首頁本身比照舊系統 MDI 主畫面的空白工作區，不再重複放一次功能卡片。
export default function Home() {
  return (
    <div className="home-page">
      <Typography.Title level={2} style={{ color: '#0f2a5c', margin: 0 }}>
        ERP2026 企業資源規劃系統
      </Typography.Title>
      <Typography.Text style={{ color: '#2c548c', fontSize: 16 }}>
        請由上方選單或工具列選擇功能項目
      </Typography.Text>
    </div>
  )
}

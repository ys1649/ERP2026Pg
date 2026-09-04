import { Typography, Tag } from 'antd'
import { useNavigate } from 'react-router-dom'
import { menuTree } from '../menuConfig'
import './Home.css'

export default function Home() {
  const navigate = useNavigate()

  return (
    <div className="home-page">
      <div className="home-hero">
        <Typography.Title level={2} style={{ color: '#fff', margin: 0 }}>
          ERP2026 企業資源規劃系統
        </Typography.Title>
        <Typography.Text style={{ color: 'rgba(255,255,255,0.75)' }}>
          請選擇下方功能項目以進入對應作業畫面
        </Typography.Text>
      </div>

      {menuTree.map((cat) => {
        const CatIcon = cat.icon
        return (
          <section className="home-section" key={cat.key}>
            <div className="home-section-title">
              <CatIcon />
              <span>{cat.label}</span>
            </div>
            <div className="home-card-grid">
              {cat.children.map((item) => {
                const ItemIcon = item.icon
                return (
                  <div
                    key={item.key}
                    className="home-card"
                    role="button"
                    tabIndex={0}
                    onClick={() => navigate(item.path)}
                    onKeyDown={(e) => {
                      if (e.key === 'Enter' || e.key === ' ') {
                        e.preventDefault()
                        navigate(item.path)
                      }
                    }}
                  >
                    <div className="home-card-icon">
                      <ItemIcon />
                    </div>
                    <div className="home-card-label">{item.label}</div>
                    <Tag
                      className="home-card-tag"
                      color={item.ready ? 'success' : 'default'}
                    >
                      {item.ready ? '可使用' : '開發中'}
                    </Tag>
                  </div>
                )
              })}
            </div>
          </section>
        )
      })}
    </div>
  )
}

import { useMemo } from 'react'
import { Layout, Menu, Breadcrumb, Typography } from 'antd'
import {
  HomeOutlined, UserOutlined, ShopOutlined, AppstoreOutlined, CarOutlined,
  ImportOutlined, DollarOutlined, WalletOutlined, FileDoneOutlined, CloudSyncOutlined,
} from '@ant-design/icons'
import { Outlet, useLocation, useNavigate } from 'react-router-dom'
import { menuTree, flatMenuItems } from '../menuConfig'
import { useReportModules } from '../hooks/useReportModules'

const { Header, Content } = Layout

// 比照舊 Delphi 主畫面（Program.DLL/MAINALL/FORM_Main.dfm）RzToolbar1 的快速操作區，
// 直接連到既有功能項目的路徑，「尚未開發」的沿用 Placeholder 頁面。
const TOOLBAR_ITEMS = [
  { key: 'toolbar-customer', label: '客戶', path: '/basic/customer', icon: UserOutlined },
  { key: 'toolbar-supplier', label: '廠商', path: '/basic/supplier', icon: ShopOutlined },
  { key: 'toolbar-product', label: '產品', path: '/basic/product', icon: AppstoreOutlined },
  { key: 'toolbar-ship', label: '銷退貨', path: '/trade/shipment', icon: CarOutlined },
  { key: 'toolbar-purchase', label: '進退單', path: '/trade/purchase', icon: ImportOutlined },
  { key: 'toolbar-ar-recv', label: '收款', path: '/trade/receivable', icon: DollarOutlined },
  { key: 'toolbar-ap-pay', label: '付款', path: '/trade/payable', icon: WalletOutlined },
  { key: 'toolbar-voucher', label: '傳票維護', path: '/gl/voucher', icon: FileDoneOutlined },
  { key: 'toolbar-backup', label: '資料備份', path: '/system/backup', icon: CloudSyncOutlined },
]

function toMenuItems(sections) {
  return sections.map((cat) => ({
    key: cat.key,
    label: cat.label,
    children: cat.children.map((item) => ({
      key: item.path,
      icon: <item.icon />,
      label: item.label,
    })),
  }))
}

export default function MainLayout() {
  const navigate = useNavigate()
  const location = useLocation()
  const reportModules = useReportModules()

  // 模組順序比照舊系統選單：基本資料/交易單據/表單報表/管理報表/統計報表/財務會計(會計總帳)/成本作業/系統設定
  const [basicCat, tradeCat, ...restCats] = menuTree
  const sections = useMemo(
    () => [basicCat, tradeCat, ...reportModules, ...restCats],
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [reportModules]
  )
  const menuItems = useMemo(() => toMenuItems(sections), [sections])
  const allFlatItems = useMemo(
    () => flatMenuItems.concat(
      reportModules.flatMap((cat) =>
        cat.children.map((item) => ({ ...item, categoryKey: cat.key, categoryLabel: cat.label }))
      )
    ),
    [reportModules]
  )

  const current = useMemo(
    () => allFlatItems.find((i) => i.path === location.pathname),
    [allFlatItems, location.pathname]
  )

  return (
    <Layout style={{ minHeight: '100vh' }}>
      <Header
        style={{
          background: 'linear-gradient(135deg, #0f2a5c 0%, #1a56b8 100%)',
          display: 'flex',
          alignItems: 'center',
          padding: '0 20px',
          gap: 20,
          height: 60,
          lineHeight: '60px',
        }}
      >
        <div
          onClick={() => navigate('/')}
          style={{ display: 'flex', alignItems: 'center', gap: 10, cursor: 'pointer', flexShrink: 0 }}
        >
          <div
            style={{
              width: 32, height: 32, borderRadius: 7, background: '#fff', color: '#0f2a5c',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              fontWeight: 700, fontSize: 16,
            }}
          >
            E
          </div>
          <Typography.Text strong style={{ fontSize: 18, color: '#fff' }}>ERP2026</Typography.Text>
        </div>
        <Menu
          mode="horizontal"
          theme="dark"
          items={menuItems}
          selectedKeys={current ? [current.path] : []}
          onClick={({ key }) => navigate(key)}
          style={{ flex: 1, minWidth: 0, background: 'transparent', fontSize: 15 }}
        />
      </Header>

      <div
        style={{
          background: '#eaf1fc',
          borderBottom: '1px solid #cfe0f5',
          display: 'flex',
          padding: '8px 16px',
          gap: 6,
          overflowX: 'auto',
        }}
      >
        {TOOLBAR_ITEMS.map((item) => (
          <div
            key={item.key}
            role="button"
            tabIndex={0}
            onClick={() => navigate(item.path)}
            onKeyDown={(e) => {
              if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault()
                navigate(item.path)
              }
            }}
            style={{
              display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
              width: 74, height: 56, borderRadius: 8, cursor: 'pointer', flexShrink: 0,
              color: '#0f2a5c', fontSize: 13, fontWeight: 500, gap: 3, userSelect: 'none',
              transition: 'background 0.15s ease',
            }}
            onMouseEnter={(e) => { e.currentTarget.style.background = '#d3e4fa' }}
            onMouseLeave={(e) => { e.currentTarget.style.background = 'transparent' }}
          >
            <item.icon style={{ fontSize: 22, color: '#155bc4' }} />
            <span>{item.label}</span>
          </div>
        ))}
      </div>

      <Layout>
        <div style={{ padding: '12px 20px 0' }}>
          <Breadcrumb
            style={{ fontSize: 15 }}
            items={[
              { title: <a onClick={() => navigate('/')}><HomeOutlined /> 首頁</a> },
              ...(current ? [{ title: current.categoryLabel }, { title: current.label }] : []),
            ]}
          />
        </div>
        <Content style={{ margin: 20 }}>
          <Outlet />
        </Content>
      </Layout>
    </Layout>
  )
}

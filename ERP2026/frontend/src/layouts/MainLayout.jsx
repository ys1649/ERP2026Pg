import { useMemo, useState } from 'react'
import { Layout, Menu, Breadcrumb, Typography, Button } from 'antd'
import { HomeOutlined, MenuFoldOutlined, MenuUnfoldOutlined } from '@ant-design/icons'
import { Outlet, useLocation, useNavigate } from 'react-router-dom'
import { menuTree, flatMenuItems } from '../menuConfig'

const { Header, Sider, Content } = Layout

const menuItems = menuTree.map((cat) => ({
  key: cat.key,
  icon: <cat.icon />,
  label: cat.label,
  children: cat.children.map((item) => ({
    key: item.path,
    icon: <item.icon />,
    label: item.label,
  })),
}))

export default function MainLayout() {
  const [collapsed, setCollapsed] = useState(false)
  const navigate = useNavigate()
  const location = useLocation()

  const current = useMemo(
    () => flatMenuItems.find((i) => i.path === location.pathname),
    [location.pathname]
  )

  return (
    <Layout style={{ minHeight: '100vh' }}>
      <Sider
        collapsible
        collapsed={collapsed}
        onCollapse={setCollapsed}
        theme="light"
        width={230}
        style={{ borderRight: '1px solid #e5e7eb' }}
      >
        <div
          onClick={() => navigate('/')}
          style={{
            height: 56,
            display: 'flex',
            alignItems: 'center',
            justifyContent: collapsed ? 'center' : 'flex-start',
            padding: collapsed ? 0 : '0 20px',
            cursor: 'pointer',
            gap: 8,
          }}
        >
          <div
            style={{
              width: 28,
              height: 28,
              borderRadius: 6,
              background: '#1677ff',
              color: '#fff',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontWeight: 700,
              fontSize: 13,
              flexShrink: 0,
            }}
          >
            E
          </div>
          {!collapsed && (
            <Typography.Text strong style={{ fontSize: 15 }}>
              ERP2026
            </Typography.Text>
          )}
        </div>
        <Menu
          mode="inline"
          items={menuItems}
          selectedKeys={current ? [current.path] : []}
          defaultOpenKeys={menuTree.map((c) => c.key)}
          onClick={({ key }) => navigate(key)}
          style={{ borderInlineEnd: 'none' }}
        />
      </Sider>

      <Layout>
        <Header
          style={{
            background: '#fff',
            borderBottom: '1px solid #e5e7eb',
            display: 'flex',
            alignItems: 'center',
            padding: '0 16px',
            gap: 12,
          }}
        >
          <Button
            type="text"
            icon={collapsed ? <MenuUnfoldOutlined /> : <MenuFoldOutlined />}
            onClick={() => setCollapsed(!collapsed)}
          />
          <Breadcrumb
            items={[
              { title: <a onClick={() => navigate('/')}><HomeOutlined /> 首頁</a> },
              ...(current ? [{ title: current.categoryLabel }, { title: current.label }] : []),
            ]}
          />
        </Header>
        <Content style={{ margin: 20 }}>
          <Outlet />
        </Content>
      </Layout>
    </Layout>
  )
}

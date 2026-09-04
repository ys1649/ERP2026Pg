import { Result, Typography } from 'antd'
import { ToolOutlined } from '@ant-design/icons'
import { useLocation } from 'react-router-dom'
import { flatMenuItems } from '../menuConfig'

export default function Placeholder() {
  const location = useLocation()
  const item = flatMenuItems.find((i) => i.path === location.pathname)

  return (
    <Result
      icon={<ToolOutlined style={{ color: '#1677ff' }} />}
      title={item ? item.label : '功能開發中'}
      subTitle={
        <Typography.Text type="secondary">
          {item ? `「${item.categoryLabel} / ${item.label}」` : '此功能'} 頁面尚未開發，敬請期待。
        </Typography.Text>
      }
    />
  )
}

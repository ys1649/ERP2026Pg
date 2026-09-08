import React from 'react'
import ReactDOM from 'react-dom/client'
import { ConfigProvider } from 'antd'
import { BrowserRouter } from 'react-router-dom'
import dayjs from 'dayjs'
import 'dayjs/locale/zh-tw'
import App from './App'
import { antdLocale, antdTheme } from './theme'
import './style.css'

dayjs.locale('zh-tw')

ReactDOM.createRoot(document.getElementById('root')).render(
  <ConfigProvider locale={antdLocale} theme={antdTheme}>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </ConfigProvider>
)

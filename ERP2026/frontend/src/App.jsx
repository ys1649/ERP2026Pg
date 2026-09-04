import { Routes, Route } from 'react-router-dom'
import MainLayout from './layouts/MainLayout'
import Home from './pages/Home'
import Placeholder from './pages/Placeholder'
import CustomerMaster from './pages/CustomerMaster'
import DataDictMaster from './pages/DataDictMaster'
import SysReportMaster from './pages/SysReportMaster'
import MssqlMigrate from './pages/MssqlMigrate'
import { flatMenuItems } from './menuConfig'

const readyComponents = {
  '/basic/customer': CustomerMaster,
  '/system/datadict': DataDictMaster,
  '/system/report': SysReportMaster,
  '/system/mssql-migrate': MssqlMigrate,
}

export default function App() {
  return (
    <Routes>
      <Route element={<MainLayout />}>
        <Route index element={<Home />} />
        {flatMenuItems.map((item) => {
          const Component = readyComponents[item.path] || Placeholder
          return <Route key={item.path} path={item.path} element={<Component />} />
        })}
      </Route>
    </Routes>
  )
}

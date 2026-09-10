import { Routes, Route } from 'react-router-dom'
import MainLayout from './layouts/MainLayout'
import Home from './pages/Home'
import Placeholder from './pages/Placeholder'
import CustomerMaster from './pages/CustomerMaster'
import SupplierMaster from './pages/SupplierMaster'
import ProductMaster from './pages/ProductMaster'
import EmployeeMaster from './pages/EmployeeMaster'
import CarMaster from './pages/CarMaster'
import AcntAccountMaster from './pages/AcntAccountMaster'
import ShipList from './pages/ShipList'
import DataDictMaster from './pages/DataDictMaster'
import SysReportMaster from './pages/SysReportMaster'
import SysReportDesignerPage from './pages/SysReportDesignerPage'
import SysReportViewPage from './pages/SysReportViewPage'
import MssqlMigrate from './pages/MssqlMigrate'
import SystemBackup from './pages/SystemBackup'
import { flatMenuItems } from './menuConfig'

const readyComponents = {
  '/basic/customer': CustomerMaster,
  '/basic/supplier': SupplierMaster,
  '/basic/product': ProductMaster,
  '/basic/employee': EmployeeMaster,
  '/basic/car': CarMaster,
  '/basic/acnt-account': AcntAccountMaster,
  '/trade/shipment': ShipList,
  '/system/datadict': DataDictMaster,
  '/system/report': SysReportMaster,
  '/system/mssql-migrate': MssqlMigrate,
  '/system/backup': SystemBackup,
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
        <Route path="/system/report/design/:srpId" element={<SysReportDesignerPage />} />
        <Route path="/report/view/:srpId" element={<SysReportViewPage />} />
      </Route>
    </Routes>
  )
}

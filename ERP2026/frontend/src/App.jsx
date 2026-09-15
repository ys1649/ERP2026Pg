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
import PurchaseList from './pages/PurchaseList'
import JournalList from './pages/JournalList'
import ArRecvList from './pages/ArRecvList'
import ApPayList from './pages/ApPayList'
import InvAdjustList from './pages/InvAdjustList'
import AssetLiabilityStatement from './pages/AssetLiabilityStatement'
import IncomeStatement from './pages/IncomeStatement'
import AccountBalanceStatement from './pages/AccountBalanceStatement'
import DailyJournal from './pages/DailyJournal'
import TrialBalance from './pages/TrialBalance'
import CashBook from './pages/CashBook'
import DetailLedger from './pages/DetailLedger'
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
  '/trade/purchase': PurchaseList,
  '/gl/voucher': JournalList,
  '/trade/receivable': ArRecvList,
  '/trade/payable': ApPayList,
  '/trade/misc': InvAdjustList,
  '/gl/balance-sheet': AssetLiabilityStatement,
  '/gl/income-statement': IncomeStatement,
  '/gl/balance': AccountBalanceStatement,
  '/gl/daily': DailyJournal,
  '/gl/trial': TrialBalance,
  '/gl/cash': CashBook,
  '/gl/detail': DetailLedger,
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
        {flatMenuItems
          .filter((item) => !item.path.startsWith('/report/view/'))
          .map((item) => {
            const Component = readyComponents[item.path] || Placeholder
            return <Route key={item.path} path={item.path} element={<Component />} />
          })}
        <Route path="/system/report/design/:srpId" element={<SysReportDesignerPage />} />
        <Route path="/report/view/:srpId" element={<SysReportViewPage />} />
      </Route>
    </Routes>
  )
}

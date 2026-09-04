import {
  UserOutlined,
  ShopOutlined,
  AppstoreOutlined,
  IdcardOutlined,
  FileTextOutlined,
  CarOutlined,
  ImportOutlined,
  DollarOutlined,
  WalletOutlined,
  SwapOutlined,
  BarChartOutlined,
  FileSearchOutlined,
  FileDoneOutlined,
  LineChartOutlined,
  PieChartOutlined,
  FundOutlined,
  CalendarOutlined,
  SafetyCertificateOutlined,
  DatabaseOutlined,
  TableOutlined,
  CloudSyncOutlined,
  PrinterOutlined,
  TeamOutlined,
  ShoppingCartOutlined,
  AccountBookOutlined,
  CalculatorOutlined,
  SettingOutlined,
  SyncOutlined,
} from '@ant-design/icons'

// 整個系統的功能目錄結構。leaf 節點若帶 ready:true 代表已經有實際頁面（component），
// 其餘尚未開發的項目會導向「開發中」的預留頁面。
export const menuTree = [
  {
    key: 'basic',
    label: '基本資料維護',
    icon: TeamOutlined,
    children: [
      { key: 'basic-customer', label: '客戶資料管理', path: '/basic/customer', icon: UserOutlined, ready: true },
      { key: 'basic-supplier', label: '廠商資料管理', path: '/basic/supplier', icon: ShopOutlined },
      { key: 'basic-product', label: '產品資料管理', path: '/basic/product', icon: AppstoreOutlined },
      { key: 'basic-employee', label: '員工資料管理', path: '/basic/employee', icon: IdcardOutlined },
    ],
  },
  {
    key: 'trade',
    label: '交易單據維護',
    icon: ShoppingCartOutlined,
    children: [
      { key: 'trade-order', label: '訂單維護', path: '/trade/order', icon: FileTextOutlined },
      { key: 'trade-shipment', label: '出貨單', path: '/trade/shipment', icon: CarOutlined },
      { key: 'trade-purchase', label: '進貨單', path: '/trade/purchase', icon: ImportOutlined },
      { key: 'trade-receivable', label: '應收帳款維護', path: '/trade/receivable', icon: DollarOutlined },
      { key: 'trade-payable', label: '應付帳款維護', path: '/trade/payable', icon: WalletOutlined },
      { key: 'trade-misc', label: '雜收發單據維護', path: '/trade/misc', icon: SwapOutlined },
    ],
  },
  {
    key: 'report',
    label: '管理報表',
    icon: BarChartOutlined,
    children: [
      { key: 'report-ap-summary', label: '應付帳款統計表', path: '/report/ap-summary', icon: BarChartOutlined },
      { key: 'report-ar-summary', label: '應收帳款統計表', path: '/report/ar-summary', icon: BarChartOutlined },
      { key: 'report-ar-detail', label: '應收帳款明細表', path: '/report/ar-detail', icon: FileSearchOutlined },
      { key: 'report-ap-detail', label: '應付帳款明細表', path: '/report/ap-detail', icon: FileSearchOutlined },
    ],
  },
  {
    key: 'gl',
    label: '會計總帳系統',
    icon: AccountBookOutlined,
    children: [
      { key: 'gl-voucher', label: '傳票維護', path: '/gl/voucher', icon: FileDoneOutlined },
      { key: 'gl-income-statement', label: '損益表', path: '/gl/income-statement', icon: LineChartOutlined },
      { key: 'gl-balance-sheet', label: '資產負債表', path: '/gl/balance-sheet', icon: PieChartOutlined },
      { key: 'gl-cashflow', label: '現金流量表', path: '/gl/cashflow', icon: FundOutlined },
    ],
  },
  {
    key: 'cost',
    label: '成本作業',
    icon: CalculatorOutlined,
    children: [
      { key: 'cost-period', label: '期間維護', path: '/cost/period', icon: CalendarOutlined },
    ],
  },
  {
    key: 'system',
    label: '系統設定',
    icon: SettingOutlined,
    children: [
      { key: 'system-permission', label: '功能權限管理', path: '/system/permission', icon: SafetyCertificateOutlined },
      { key: 'system-data', label: '系統資料設定', path: '/system/data', icon: DatabaseOutlined },
      { key: 'system-datadict', label: '資料字典維護', path: '/system/datadict', icon: TableOutlined, ready: true },
      { key: 'system-backup', label: '系統備份與還原', path: '/system/backup', icon: CloudSyncOutlined },
      { key: 'system-report', label: '系統報表管理', path: '/system/report', icon: PrinterOutlined, ready: true },
      { key: 'system-mssql-migrate', label: 'MSSQL 資料轉入', path: '/system/mssql-migrate', icon: SyncOutlined, ready: true },
    ],
  },
]

// 攤平成 { path, label, categoryLabel, icon, ready } 陣列，方便路由與麵包屑查找。
export const flatMenuItems = menuTree.flatMap((cat) =>
  cat.children.map((item) => ({ ...item, categoryKey: cat.key, categoryLabel: cat.label }))
)

import logging
from pathlib import Path

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import (
    customers,
    reports,
    data_dict,
    sysreport,
    mssql_migrate,
    suppliers,
    products,
    employees,
    cars,
    acnt_accounts,
    ship,
)

LOG_FILE = Path(__file__).resolve().parent / "uvicorn_8000.log"
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(name)s: %(message)s",
    handlers=[logging.StreamHandler(), logging.FileHandler(LOG_FILE, encoding="utf-8")],
    force=True,
)

app = FastAPI(title="ERP2026 API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(customers.router, prefix="/api/customers", tags=["customers"])
app.include_router(reports.router, prefix="/api/reports", tags=["reports"])
app.include_router(data_dict.router, prefix="/api/datadict", tags=["data-dict"])
app.include_router(sysreport.router, prefix="/api/sysreport", tags=["sysreport"])
app.include_router(mssql_migrate.router, prefix="/api/mssql-migrate", tags=["mssql-migrate"])
app.include_router(suppliers.router, prefix="/api/suppliers", tags=["suppliers"])
app.include_router(products.router, prefix="/api/products", tags=["products"])
app.include_router(employees.router, prefix="/api/employees", tags=["employees"])
app.include_router(cars.router, prefix="/api/cars", tags=["cars"])
app.include_router(acnt_accounts.router, prefix="/api/acnt-accounts", tags=["acnt-accounts"])
app.include_router(ship.router, prefix="/api/ship", tags=["ship"])

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)

import os
import tempfile
from datetime import datetime

from fastapi import APIRouter, HTTPException, UploadFile
from fastapi.responses import FileResponse
from starlette.background import BackgroundTask

from database import HOST, PORT, DBNAME, USER, PASSWORD

router = APIRouter()

BACKUPS_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "scripts", "backups")

TABLES = ["tblsysreport", "tblsysreportfield", "tbldd", "tbl_ddfield"]


def _pg_env():
    env = os.environ.copy()
    env["PGPASSWORD"] = PASSWORD
    return env


def _run_pg_dump(output_path: str):
    import subprocess

    table_args = []
    for t in TABLES:
        table_args += ["-t", t]

    result = subprocess.run(
        [
            "pg_dump", "-h", HOST, "-p", str(PORT), "-U", USER, "-d", DBNAME,
            "-F", "p", "--no-owner", "--no-privileges", "--clean", "--if-exists",
            *table_args,
            "-f", output_path,
        ],
        env=_pg_env(), capture_output=True, text=True,
    )
    if result.returncode != 0:
        raise HTTPException(500, f"備份失敗: {result.stderr}")


@router.get("/export")
def export_report_backup():
    """匯出報表相關 4 張表（TBLSYSREPORT/TBLSYSREPORTFIELD/TBLDD/TBL_DDFIELD）結構+內容為單一 .sql 檔案，供下載。"""
    ts = datetime.now().strftime("%Y%m%d_%H%M")
    tmp_fd, tmp_path = tempfile.mkstemp(suffix=".sql")
    os.close(tmp_fd)
    _run_pg_dump(tmp_path)
    return FileResponse(
        tmp_path,
        media_type="application/sql",
        filename=f"SYSREPORT{ts}.sql",
        background=BackgroundTask(os.remove, tmp_path),
    )


@router.post("/restore")
async def restore_report_backup(file: UploadFile):
    """還原：上傳報表備份 .sql 檔案 → 還原前先在伺服器留一份安全備份 → 用 psql 單一交易重建這 4 張表並灌回資料。"""
    import subprocess

    if not file.filename or not file.filename.lower().endswith(".sql"):
        raise HTTPException(400, "請上傳 .sql 備份檔案")

    tmp_fd, tmp_path = tempfile.mkstemp(suffix=".sql")
    try:
        with os.fdopen(tmp_fd, "wb") as f:
            content = await file.read()
            f.write(content)

        if not content or b"PostgreSQL database dump" not in content[:2000]:
            raise HTTPException(400, "檔案內容不像是有效的備份檔（找不到 pg_dump 標頭）")

        os.makedirs(BACKUPS_DIR, exist_ok=True)
        ts = datetime.now().strftime("%Y%m%d_%H%M")
        safety_filename = f"pre_report_restore_{ts}.sql"
        _run_pg_dump(os.path.join(BACKUPS_DIR, safety_filename))

        result = subprocess.run(
            [
                "psql", "-h", HOST, "-p", str(PORT), "-U", USER, "-d", DBNAME,
                "-v", "ON_ERROR_STOP=1", "--single-transaction", "-f", tmp_path,
            ],
            env=_pg_env(), capture_output=True, text=True,
        )
        if result.returncode != 0:
            raise HTTPException(500, f"還原失敗，資料庫未被變更: {result.stderr}")

        return {"message": "還原完成", "safety_backup": safety_filename}
    finally:
        os.remove(tmp_path)

-- 1. 刪除舊的（先刪 DB 再刪 Role，順序不能反，
--    因為 Role 還擁有 DB 的時候是刪不掉的）
DROP DATABASE IF EXISTS erp;
DROP ROLE IF EXISTS erpuser;

-- 2. 建立 Login User
CREATE ROLE erpuser WITH LOGIN PASSWORD 'erpuser';

-- 3. 建立 Database，指定 owner
CREATE DATABASE erp
    WITH
    OWNER = erpuser
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;
	
ALTER SCHEMA public OWNER TO erpuser;	
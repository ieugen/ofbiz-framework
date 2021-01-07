--
-- Create postgresql database and user for demo.
--
create user ofbiz with password 'ofbiz';
create database ofbiz with owner 'ofbiz';
create database ofbizolap with owner ofbiz;
create database ofbiztenant with owner ofbiz;
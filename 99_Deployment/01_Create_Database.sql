/******************************************************************************
Project  : Enterprise Banking Data Platform
Script   : 01_Create_Database.sql
Author   : Rakesh Soma
Purpose  : Create BankingERP Database
******************************************************************************/

USE master;
GO

IF DB_ID('BankingERP') IS NULL
BEGIN
    CREATE DATABASE BankingERP;

    PRINT '========================================';
    PRINT 'BankingERP Database Created Successfully';
    PRINT '========================================';
END
ELSE
BEGIN
    PRINT '========================================';
    PRINT 'BankingERP Database Already Exists';
    PRINT '========================================';
END
GO
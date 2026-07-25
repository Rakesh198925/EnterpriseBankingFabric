/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Database Schema
Script     : 04_Create_Transaction_Schema.sql
Purpose    : Create Transaction schema
******************************************************************************/

USE BankingERP;
GO

PRINT 'CREATING TRANSACTION SCHEMA';
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name = 'Transaction'
)
BEGIN
    EXEC('CREATE SCHEMA [Transaction]');
END
GO

PRINT 'TRANSACTION SCHEMA CREATED SUCCESSFULLY';
GO
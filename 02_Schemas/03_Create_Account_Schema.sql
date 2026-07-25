/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Database Schema
Script     : 03_Create_Account_Schema.sql
Purpose    : Create Account schema
******************************************************************************/

USE BankingERP;
GO

PRINT 'CREATING ACCOUNT SCHEMA';
GO


IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name='Account'
)
BEGIN
    EXEC('CREATE SCHEMA Account');
END
GO


PRINT 'ACCOUNT SCHEMA CREATED SUCCESSFULLY';
GO
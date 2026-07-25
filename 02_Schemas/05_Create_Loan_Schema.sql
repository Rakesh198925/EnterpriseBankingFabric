/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Database Schema
Script     : 05_Create_Loan_Schema.sql
Purpose    : Create Loan schema
******************************************************************************/

USE BankingERP;
GO

PRINT 'CREATING LOAN SCHEMA';
GO


IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name='Loan'
)
BEGIN
    EXEC('CREATE SCHEMA Loan');
END
GO


PRINT 'LOAN SCHEMA CREATED SUCCESSFULLY';
GO
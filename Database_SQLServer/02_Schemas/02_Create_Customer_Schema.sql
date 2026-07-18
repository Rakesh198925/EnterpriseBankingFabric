/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Database Schema
Script     : 02_Create_Customer_Schema.sql
Purpose    : Create Customer schema
******************************************************************************/

USE BankingERP;
GO

PRINT 'CREATING CUSTOMER SCHEMA';
GO


IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name='Customer'
)
BEGIN
    EXEC('CREATE SCHEMA Customer');
END
GO


PRINT 'CUSTOMER SCHEMA CREATED SUCCESSFULLY';
GO
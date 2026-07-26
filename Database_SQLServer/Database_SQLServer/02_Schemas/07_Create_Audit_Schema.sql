/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Database Schema
Script     : 07_Create_Audit_Schema.sql
Purpose    : Create Audit schema
******************************************************************************/

USE BankingERP;
GO

PRINT 'CREATING AUDIT SCHEMA';
GO


IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name='Audit'
)
BEGIN
    EXEC('CREATE SCHEMA Audit');
END
GO


PRINT 'AUDIT SCHEMA CREATED SUCCESSFULLY';
GO
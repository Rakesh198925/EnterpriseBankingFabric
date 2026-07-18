/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Database Schema
Script     : 06_Create_Card_Schema.sql
Purpose    : Create Card schema
******************************************************************************/

USE BankingERP;
GO

PRINT 'CREATING CARD SCHEMA';
GO


IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name='Card'
)
BEGIN
    EXEC('CREATE SCHEMA Card');
END
GO


PRINT 'CARD SCHEMA CREATED SUCCESSFULLY';
GO
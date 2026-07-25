/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Database Schema
Script     : 01_Create_Master_Schema.sql
Purpose    : Create Master schema
******************************************************************************/

USE BankingERP;
GO

PRINT 'CREATING MASTER SCHEMA';
GO


IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name='Master'
)
BEGIN
    EXEC('CREATE SCHEMA Master');
END
GO


PRINT 'MASTER SCHEMA CREATED SUCCESSFULLY';
GO
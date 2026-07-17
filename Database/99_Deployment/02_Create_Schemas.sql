/******************************************************************************
Project  : Enterprise Banking Data Platform
Script   : 02_Create_Schemas.sql
Author   : Rakesh Soma
******************************************************************************/

USE BankingERP;
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name='Master')
EXEC('CREATE SCHEMA Master');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name='Customer')
EXEC('CREATE SCHEMA Customer');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name='Account')
EXEC('CREATE SCHEMA Account');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name='Loan')
EXEC('CREATE SCHEMA Loan');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name='Card')
EXEC('CREATE SCHEMA Card');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name='Transaction')
EXEC('CREATE SCHEMA [Transaction]');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name='Audit')
EXEC('CREATE SCHEMA Audit');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name='Security')
EXEC('CREATE SCHEMA Security');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name='Reporting')
EXEC('CREATE SCHEMA Reporting');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name='Staging')
EXEC('CREATE SCHEMA Staging');
GO

PRINT '========================================';
PRINT 'All Schemas Created Successfully';
PRINT '========================================';
GO
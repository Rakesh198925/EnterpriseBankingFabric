/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Master
Script     : 02_Create_CurrencyMaster_Table.sql
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Master.CurrencyMaster','U') IS NULL
BEGIN

CREATE TABLE Master.CurrencyMaster
(
    CurrencyID INT IDENTITY(1,1)
        CONSTRAINT PK_CurrencyMaster PRIMARY KEY,

    CurrencyCode CHAR(3) NOT NULL
        CONSTRAINT UQ_CurrencyMaster_Code UNIQUE,

    CurrencyName NVARCHAR(100) NOT NULL,

    Symbol NVARCHAR(10),

    DecimalPlaces TINYINT NOT NULL DEFAULT 2,

    Description NVARCHAR(250),

    IsActive BIT NOT NULL DEFAULT 1,

    CreatedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SUSER_SNAME(),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy NVARCHAR(100) NULL
);

END
GO
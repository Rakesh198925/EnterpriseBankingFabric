/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Master
Script     : 01_Create_CountryMaster_Table.sql
Author     : Rakesh Soma
Purpose    : Create Country Master table
******************************************************************************/

USE BankingERP;
GO

PRINT '=============================================';
PRINT 'CREATING MASTER.COUNTRYMASTER TABLE';
PRINT '=============================================';
GO

IF OBJECT_ID('Master.CountryMaster','U') IS NULL
BEGIN

    CREATE TABLE Master.CountryMaster
    (
        CountryID INT IDENTITY(1,1)
            CONSTRAINT PK_CountryMaster PRIMARY KEY,

        CountryCode CHAR(2) NOT NULL
            CONSTRAINT UQ_CountryMaster_Code UNIQUE,

        CountryName NVARCHAR(100) NOT NULL,

        ISOCode3 CHAR(3) NULL,

        CurrencyCode CHAR(3) NULL,

        Description NVARCHAR(250) NULL,

        IsActive BIT NOT NULL
            DEFAULT(1),

        CreatedDate DATETIME2 NOT NULL
            DEFAULT SYSUTCDATETIME(),

        CreatedBy NVARCHAR(100) NOT NULL
            DEFAULT SUSER_SNAME(),

        ModifiedDate DATETIME2 NULL,

        ModifiedBy NVARCHAR(100) NULL
    );

    PRINT 'CountryMaster table created successfully.';

END
ELSE
BEGIN
    PRINT 'CountryMaster table already exists.';
END
GO
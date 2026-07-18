/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Master
Script     : 04_Create_CustomerTypeMaster_Table.sql
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Master.CustomerTypeMaster','U') IS NULL
BEGIN

CREATE TABLE Master.CustomerTypeMaster
(
    CustomerTypeID INT IDENTITY(1,1)
        CONSTRAINT PK_CustomerTypeMaster PRIMARY KEY,

    CustomerTypeCode VARCHAR(20) NOT NULL
        CONSTRAINT UQ_CustomerTypeMaster_Code UNIQUE,

    CustomerTypeName NVARCHAR(100) NOT NULL,

    Description NVARCHAR(250),

    IsActive BIT NOT NULL DEFAULT 1,

    CreatedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SUSER_SNAME(),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy NVARCHAR(100) NULL
);

END
GO
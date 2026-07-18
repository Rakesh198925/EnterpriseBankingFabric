/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Master
Script     : 03_Create_BranchMaster_Table.sql
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Master.BranchMaster','U') IS NULL
BEGIN

CREATE TABLE Master.BranchMaster
(
    BranchID INT IDENTITY(1,1)
        CONSTRAINT PK_BranchMaster PRIMARY KEY,

    BranchCode VARCHAR(20) NOT NULL
        CONSTRAINT UQ_BranchMaster_Code UNIQUE,

    BranchName NVARCHAR(100) NOT NULL,

    CountryID INT NOT NULL,

    City NVARCHAR(100),

    AddressLine1 NVARCHAR(200),

    PostalCode NVARCHAR(20),

    IsActive BIT NOT NULL DEFAULT 1,

    CreatedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SUSER_SNAME(),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy NVARCHAR(100) NULL,

    CONSTRAINT FK_BranchMaster_Country
        FOREIGN KEY (CountryID)
        REFERENCES Master.CountryMaster(CountryID)
);

END
GO
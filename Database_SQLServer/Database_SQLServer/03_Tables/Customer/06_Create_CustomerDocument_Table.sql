/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer
Script     : 06_Create_CustomerDocument_Table.sql
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Customer.CustomerDocument','U') IS NULL
BEGIN

CREATE TABLE Customer.CustomerDocument
(
    CustomerDocumentID INT IDENTITY(1,1)
        CONSTRAINT PK_CustomerDocument PRIMARY KEY,

    CustomerID INT NOT NULL,

    DocumentType VARCHAR(50) NOT NULL,

    DocumentReference VARCHAR(100) NOT NULL,

    IssuingCountryID INT NOT NULL,

    IssueDate DATE NULL,

    ExpiryDate DATE NULL,

    DocumentStatus VARCHAR(30) NOT NULL,

    VerifiedDate DATE NULL,

    VerifiedBy NVARCHAR(100) NULL,

    IsActive BIT NOT NULL DEFAULT 1,

    CreatedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SUSER_SNAME(),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy NVARCHAR(100) NULL,

    CONSTRAINT FK_CustomerDocument_Customer
        FOREIGN KEY(CustomerID)
        REFERENCES Customer.Customer(CustomerID),

    CONSTRAINT FK_CustomerDocument_Country
        FOREIGN KEY(IssuingCountryID)
        REFERENCES Master.CountryMaster(CountryID)

);

END
GO
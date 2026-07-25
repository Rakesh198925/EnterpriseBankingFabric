/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer
Script     : 08_Create_CustomerConsent_Table.sql
Author     : Rakesh Soma
Purpose    : Create Customer Consent table
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Customer.CustomerConsent','U') IS NULL
BEGIN

CREATE TABLE Customer.CustomerConsent
(
    CustomerConsentID INT IDENTITY(1,1)
        CONSTRAINT PK_CustomerConsent PRIMARY KEY,

    CustomerID INT NOT NULL,

    ConsentType VARCHAR(50) NOT NULL,
        -- GDPR
        -- Marketing
        -- Profiling
        -- Electronic Communication

    ConsentStatus BIT NOT NULL,

    ConsentDate DATETIME2 NOT NULL,

    ExpiryDate DATE NULL,

    ConsentSource VARCHAR(50),

    Remarks NVARCHAR(500),

    CreatedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SUSER_SNAME(),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy NVARCHAR(100) NULL,

    CONSTRAINT FK_CustomerConsent_Customer
        FOREIGN KEY(CustomerID)
        REFERENCES Customer.Customer(CustomerID)
);

END
GO
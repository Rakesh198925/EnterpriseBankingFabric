/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer
Script     : 04_Create_CustomerKYC_Table.sql
Author     : Rakesh Soma
Purpose    : Create Customer KYC table
******************************************************************************/

USE BankingERP;
GO

PRINT '=============================================';
PRINT 'CREATING CUSTOMER.CUSTOMERKYC TABLE';
PRINT '=============================================';
GO

IF OBJECT_ID('Customer.CustomerKYC','U') IS NULL
BEGIN

CREATE TABLE Customer.CustomerKYC
(
    CustomerKYCID INT IDENTITY(1,1)
        CONSTRAINT PK_CustomerKYC PRIMARY KEY,

    CustomerID INT NOT NULL,

    KYCReferenceNumber VARCHAR(50) NOT NULL
        CONSTRAINT UQ_CustomerKYC_Reference UNIQUE,

    IdentificationType VARCHAR(50) NOT NULL,
        -- Passport
        -- National ID Card
        -- Residence Permit
        -- Driving Licence

    IdentificationNumber VARCHAR(100) NOT NULL,

    IssuingCountryID INT NOT NULL,

    IssueDate DATE NULL,

    ExpiryDate DATE NULL,

    TaxIdentificationNumber VARCHAR(50) NULL,

    FATCAStatus VARCHAR(20) NULL,

    CRSStatus VARCHAR(20) NULL,

    PEPIndicator BIT NOT NULL DEFAULT 0,

    SanctionsScreeningStatus VARCHAR(30) NOT NULL,

    AMLRiskRating VARCHAR(20) NOT NULL,

    KYCStatus VARCHAR(30) NOT NULL,

    VerificationDate DATE NULL,

    VerifiedBy NVARCHAR(100) NULL,

    ReviewDueDate DATE NULL,

    IsActive BIT NOT NULL DEFAULT 1,

    CreatedDate DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    CreatedBy NVARCHAR(100) NOT NULL
        DEFAULT SUSER_SNAME(),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy NVARCHAR(100) NULL,

    CONSTRAINT FK_CustomerKYC_Customer
        FOREIGN KEY(CustomerID)
        REFERENCES Customer.Customer(CustomerID),

    CONSTRAINT FK_CustomerKYC_Country
        FOREIGN KEY(IssuingCountryID)
        REFERENCES Master.CountryMaster(CountryID)
);

END
GO

PRINT 'CustomerKYC table created successfully';
GO
/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer
Script     : 05_Create_CustomerEmployment_Table.sql
Author     : Rakesh Soma
Purpose    : Create Customer Employment table
******************************************************************************/

USE BankingERP;
GO

PRINT '=============================================';
PRINT 'CREATING CUSTOMER.CUSTOMEREMPLOYMENT TABLE';
PRINT '=============================================';
GO

IF OBJECT_ID('Customer.CustomerEmployment','U') IS NULL
BEGIN

CREATE TABLE Customer.CustomerEmployment
(
    CustomerEmploymentID INT IDENTITY(1,1)
        CONSTRAINT PK_CustomerEmployment PRIMARY KEY,

    CustomerID INT NOT NULL,

    EmploymentStatus VARCHAR(30) NOT NULL,
        -- Employed, Self-Employed, Unemployed, Student, Retired

    EmployerName NVARCHAR(200) NULL,

    JobTitle NVARCHAR(100) NULL,

    Industry NVARCHAR(100) NULL,

    EmploymentStartDate DATE NULL,

    AnnualIncome DECIMAL(18,2) NULL,

    IncomeCurrencyCode CHAR(3) NULL,

    SourceOfFunds NVARCHAR(100) NULL,

    SourceOfWealth NVARCHAR(100) NULL,

    TaxResidenceCountryID INT NULL,

    IsActive BIT NOT NULL DEFAULT 1,

    CreatedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SUSER_SNAME(),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy NVARCHAR(100) NULL,

    CONSTRAINT FK_CustomerEmployment_Customer
        FOREIGN KEY(CustomerID)
        REFERENCES Customer.Customer(CustomerID),

    CONSTRAINT FK_CustomerEmployment_Country
        FOREIGN KEY(TaxResidenceCountryID)
        REFERENCES Master.CountryMaster(CountryID)

);

END
GO

PRINT 'CustomerEmployment table created successfully';
GO
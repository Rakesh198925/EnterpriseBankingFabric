/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer
Script     : 01_Create_Customer_Table.sql
Author     : Rakesh Soma
Purpose    : Create Customer table
******************************************************************************/

USE BankingERP;
GO

PRINT '=============================================';
PRINT 'CREATING CUSTOMER.CUSTOMER TABLE';
PRINT '=============================================';
GO

IF OBJECT_ID('Customer.Customer','U') IS NULL
BEGIN

CREATE TABLE Customer.Customer
(
    CustomerID INT IDENTITY(100000,1)
        CONSTRAINT PK_Customer PRIMARY KEY,

    CustomerNumber VARCHAR(20) NOT NULL
        CONSTRAINT UQ_Customer_Number UNIQUE,

    FirstName NVARCHAR(100) NOT NULL,

    MiddleName NVARCHAR(100) NULL,

    LastName NVARCHAR(100) NOT NULL,

    DateOfBirth DATE NOT NULL,

    Gender CHAR(1) NOT NULL,

    MaritalStatus VARCHAR(20) NULL,

    CustomerTypeID INT NOT NULL,

    RiskCategoryID INT NOT NULL,

    OccupationID INT NULL,

    BranchID INT NOT NULL,

    NationalityCountryID INT NULL,

    EmailAddress NVARCHAR(200) NULL,

    MobileNumber VARCHAR(20) NULL,

    PANNumber VARCHAR(20) NULL,

    TaxIdentificationNumber VARCHAR(50) NULL,

    CustomerStatus VARCHAR(20) NOT NULL
        DEFAULT 'Active',

    KYCStatus VARCHAR(20) NOT NULL
        DEFAULT 'Pending',

    IsActive BIT NOT NULL
        DEFAULT 1,

    CreatedDate DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    CreatedBy NVARCHAR(100) NOT NULL
        DEFAULT SUSER_SNAME(),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy NVARCHAR(100) NULL,

    CONSTRAINT FK_Customer_CustomerType
        FOREIGN KEY(CustomerTypeID)
        REFERENCES Master.CustomerTypeMaster(CustomerTypeID),

    CONSTRAINT FK_Customer_RiskCategory
        FOREIGN KEY(RiskCategoryID)
        REFERENCES Master.RiskCategoryMaster(RiskCategoryID),

    CONSTRAINT FK_Customer_Occupation
        FOREIGN KEY(OccupationID)
        REFERENCES Master.OccupationMaster(OccupationID),

    CONSTRAINT FK_Customer_Branch
        FOREIGN KEY(BranchID)
        REFERENCES Master.BranchMaster(BranchID),

    CONSTRAINT FK_Customer_Country
        FOREIGN KEY(NationalityCountryID)
        REFERENCES Master.CountryMaster(CountryID)
);

PRINT 'Customer.Customer table created successfully.';

END
ELSE
BEGIN
    PRINT 'Customer.Customer table already exists.';
END
GO

PRINT '=============================================';
PRINT 'CUSTOMER TABLE DEPLOYMENT COMPLETED';
PRINT '=============================================';
GO
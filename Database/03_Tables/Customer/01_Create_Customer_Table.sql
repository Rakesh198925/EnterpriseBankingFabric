/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer Management
Script     : 01_Create_Customer_Table.sql
Author     : Rakesh Soma
Purpose    : Create Customer.Customer table
******************************************************************************/

USE BankingERP;
GO

PRINT '=============================================';
PRINT 'CREATING CUSTOMER TABLE';
PRINT '=============================================';
GO

IF OBJECT_ID('Customer.Customer', 'U') IS NOT NULL
BEGIN
    DROP TABLE Customer.Customer;
END
GO

CREATE TABLE Customer.Customer
(
    ---------------------------------------------------------
    -- Primary Key
    ---------------------------------------------------------
    CustomerID INT IDENTITY(1,1) NOT NULL,

    ---------------------------------------------------------
    -- Business Key
    ---------------------------------------------------------
    CustomerNumber VARCHAR(20) NOT NULL,

    ---------------------------------------------------------
    -- Master References (Foreign Keys will be added later)
    ---------------------------------------------------------
    CustomerTypeID INT NOT NULL,
    BranchID INT NOT NULL,
    RiskCategoryID INT NOT NULL,
    OccupationID INT NULL,

    NationalityCountryID INT NOT NULL,
    ResidenceCountryID INT NOT NULL,

    ---------------------------------------------------------
    -- Personal Information
    ---------------------------------------------------------
    Title VARCHAR(10) NULL,
    FirstName VARCHAR(100) NOT NULL,
    MiddleName VARCHAR(100) NULL,
    LastName VARCHAR(100) NOT NULL,

    DateOfBirth DATE NOT NULL,
    Gender CHAR(1) NOT NULL,

    ---------------------------------------------------------
    -- Contact Information
    ---------------------------------------------------------
    MobileNumber VARCHAR(20) NULL,
    EmailAddress VARCHAR(150) NULL,

    PreferredLanguage VARCHAR(10) NOT NULL,

    ---------------------------------------------------------
    -- Banking Details
    ---------------------------------------------------------
    CustomerSegment VARCHAR(30) NOT NULL,
    CustomerStatus VARCHAR(20) NOT NULL,

    IsPEP BIT NOT NULL
        CONSTRAINT DF_Customer_IsPEP DEFAULT (0),

    IsAMLWatch BIT NOT NULL
        CONSTRAINT DF_Customer_IsAMLWatch DEFAULT (0),

    ---------------------------------------------------------
    -- Audit Columns
    ---------------------------------------------------------
    IsActive BIT NOT NULL
        CONSTRAINT DF_Customer_IsActive DEFAULT (1),

    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Customer_CreatedDate DEFAULT (SYSDATETIME()),

    CreatedBy NVARCHAR(100) NOT NULL
        CONSTRAINT DF_Customer_CreatedBy DEFAULT (SUSER_SNAME()),

    ModifiedDate DATETIME2 NULL,
    ModifiedBy NVARCHAR(100) NULL,

    ---------------------------------------------------------
    -- Primary Key
    ---------------------------------------------------------
    CONSTRAINT PK_Customer
        PRIMARY KEY CLUSTERED (CustomerID),

    ---------------------------------------------------------
    -- Unique Constraint
    ---------------------------------------------------------
    CONSTRAINT UQ_Customer_CustomerNumber
        UNIQUE (CustomerNumber),

    ---------------------------------------------------------
    -- Check Constraints
    ---------------------------------------------------------
    CONSTRAINT CK_Customer_Gender
        CHECK (Gender IN ('M','F','O')),

    CONSTRAINT CK_Customer_Status
        CHECK (CustomerStatus IN
        ('Active','Inactive','Blocked','Closed')),

    CONSTRAINT CK_Customer_Language
        CHECK (PreferredLanguage IN
        ('EN','FR','DE','LU')),

    CONSTRAINT CK_Customer_Segment
        CHECK (CustomerSegment IN
        ('Retail','SME','Corporate','Private Banking'))
);
GO

PRINT '=============================================';
PRINT 'CUSTOMER TABLE CREATED SUCCESSFULLY';
PRINT '=============================================';
GO
/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer
Script     : 03_Create_CustomerContact_Table.sql
Author     : Rakesh Soma
Purpose    : Create Customer Contact table
******************************************************************************/

USE BankingERP;
GO

PRINT '=============================================';
PRINT 'CREATING CUSTOMER.CUSTOMERCONTACT TABLE';
PRINT '=============================================';
GO

IF OBJECT_ID('Customer.CustomerContact','U') IS NULL
BEGIN

CREATE TABLE Customer.CustomerContact
(
    CustomerContactID INT IDENTITY(1,1)
        CONSTRAINT PK_CustomerContact PRIMARY KEY,

    CustomerID INT NOT NULL,

    ContactType VARCHAR(20) NOT NULL,      -- Mobile, Home, Office, Emergency

    ContactNumber VARCHAR(20) NOT NULL,

    EmailAddress NVARCHAR(200) NULL,

    EmergencyContactName NVARCHAR(100) NULL,

    EmergencyContactNumber VARCHAR(20) NULL,

    PreferredContactMethod VARCHAR(20) NULL,

    IsPrimary BIT NOT NULL DEFAULT 1,

    IsActive BIT NOT NULL DEFAULT 1,

    CreatedDate DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    CreatedBy NVARCHAR(100) NOT NULL
        DEFAULT SUSER_SNAME(),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy NVARCHAR(100) NULL,

    CONSTRAINT FK_CustomerContact_Customer
        FOREIGN KEY(CustomerID)
        REFERENCES Customer.Customer(CustomerID)
);

END
GO

PRINT 'CustomerContact table created successfully';
GO
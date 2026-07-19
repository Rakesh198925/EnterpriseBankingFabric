/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer
Script     : 02_Create_CustomerAddress_Table.sql
Author     : Rakesh Soma
Purpose    : Create Customer Address table
******************************************************************************/

USE BankingERP;
GO

PRINT '=============================================';
PRINT 'CREATING CUSTOMER.CUSTOMERADDRESS TABLE';
PRINT '=============================================';
GO

IF OBJECT_ID('Customer.CustomerAddress','U') IS NULL
BEGIN

CREATE TABLE Customer.CustomerAddress
(
    CustomerAddressID INT IDENTITY(1,1)
        CONSTRAINT PK_CustomerAddress PRIMARY KEY,

    CustomerID INT NOT NULL,

    AddressType VARCHAR(20) NOT NULL,      -- Home, Office, Mailing

    AddressLine1 NVARCHAR(200) NOT NULL,

    AddressLine2 NVARCHAR(200) NULL,

    City NVARCHAR(100) NOT NULL,

    StateProvince NVARCHAR(100) NOT NULL,

    PostalCode NVARCHAR(20) NOT NULL,

    CountryID INT NOT NULL,

    IsPrimary BIT NOT NULL DEFAULT 0,

    IsActive BIT NOT NULL DEFAULT 1,

    CreatedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SUSER_SNAME(),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy NVARCHAR(100) NULL,

    CONSTRAINT FK_CustomerAddress_Customer
        FOREIGN KEY(CustomerID)
        REFERENCES Customer.Customer(CustomerID),

    CONSTRAINT FK_CustomerAddress_Country
        FOREIGN KEY(CountryID)
        REFERENCES Master.CountryMaster(CountryID)
);

END
GO

PRINT 'CustomerAddress table created successfully';
GO
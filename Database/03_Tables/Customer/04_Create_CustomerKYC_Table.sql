/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer Management
Script     : 04_Create_CustomerAddress_Table.sql
Author     : Rakesh Soma
Purpose    : Create Customer.CustomerAddress table
******************************************************************************/



USE BankingERP;
GO

CREATE TABLE Customer.CustomerAddress
(
    CustomerAddressID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    CountryID INT NOT NULL,
    AddressType VARCHAR(20) NOT NULL,
    AddressLine1 VARCHAR(200) NOT NULL,
    AddressLine2 VARCHAR(200) NULL,
    City VARCHAR(100) NOT NULL,
    StateProvince VARCHAR(100) NULL,
    PostalCode VARCHAR(20) NOT NULL,
    IsPrimary BIT NOT NULL DEFAULT(0),
    IsCorrespondence BIT NOT NULL DEFAULT(0),
    IsActive BIT NOT NULL DEFAULT(1),
    CreatedDate DATETIME2 NOT NULL DEFAULT(SYSDATETIME()),
    CreatedBy NVARCHAR(100) NOT NULL DEFAULT(SUSER_SNAME()),
    ModifiedDate DATETIME2 NULL,
    ModifiedBy NVARCHAR(100) NULL,

    CONSTRAINT CK_CustomerAddress_Type
    CHECK (AddressType IN
    (
        'Residential',
        'Mailing',
        'Office',
        'Temporary'
    ))
);
GO

/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer Management
Script     : 04_Create_CustomerAddress_Table.sql
Author     : Rakesh Soma
Purpose    : Create Customer.CustomerAddress table
******************************************************************************/

USE BankingERP;
GO

PRINT '=============================================';
PRINT 'CREATING CUSTOMER ADDRESS TABLE';
PRINT '=============================================';
GO

IF OBJECT_ID('Customer.CustomerAddress','U') IS NOT NULL
BEGIN
    DROP TABLE Customer.CustomerAddress;
END
GO

CREATE TABLE Customer.CustomerAddress
(
    ---------------------------------------------------------
    -- Primary Key
    ---------------------------------------------------------
    CustomerAddressID       INT IDENTITY(1,1) NOT NULL,

    ---------------------------------------------------------
    -- Foreign Key
    ---------------------------------------------------------
    CustomerID              INT NOT NULL,

    CountryID               INT NOT NULL,

    ---------------------------------------------------------
    -- Address Details
    ---------------------------------------------------------
    AddressType             VARCHAR(20) NOT NULL,

    AddressLine1            VARCHAR(200) NOT NULL,
    AddressLine2            VARCHAR(200) NULL,

    City                    VARCHAR(100) NOT NULL,
    StateProvince           VARCHAR(100) NULL,
    PostalCode              VARCHAR(20) NOT NULL,

    ---------------------------------------------------------
    -- Flags
    ---------------------------------------------------------
    IsPrimary               BIT NOT NULL,
    IsCorrespondence        BIT NOT NULL,

    ---------------------------------------------------------
    -- Audit
    ---------------------------------------------------------
    IsActive                BIT NOT NULL,

    CreatedDate             DATETIME2 NOT NULL,
    CreatedBy               NVARCHAR(100) NOT NULL,

    ModifiedDate            DATETIME2 NULL,
    ModifiedBy              NVARCHAR(100) NULL,

    ---------------------------------------------------------
    -- Constraints
    ---------------------------------------------------------
    CONSTRAINT PK_CustomerAddress
        PRIMARY KEY CLUSTERED(CustomerAddressID),

    CONSTRAINT CK_CustomerAddress_Type
        CHECK (AddressType IN
        (
            'Residential',
            'Mailing',
            'Office',
            'Temporary'
        )),

    CONSTRAINT DF_CustomerAddress_IsPrimary
        DEFAULT(0) FOR IsPrimary,

    CONSTRAINT DF_CustomerAddress_IsCorrespondence
        DEFAULT(0) FOR IsCorrespondence,

    CONSTRAINT DF_CustomerAddress_IsActive
        DEFAULT(1) FOR IsActive,

    CONSTRAINT DF_CustomerAddress_CreatedDate
        DEFAULT(SYSDATETIME()) FOR CreatedDate,

    CONSTRAINT DF_CustomerAddress_CreatedBy
        DEFAULT(SUSER_SNAME()) FOR CreatedBy
);
GO

PRINT 'CustomerAddress table created successfully.';
GO
/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer Management
Script     : 05_Create_CustomerAddress_Indexes.sql
Author     : Rakesh Soma
Purpose    : Create indexes for Customer.CustomerAddress
******************************************************************************/

USE BankingERP;
GO

PRINT '=============================================';
PRINT 'CREATING CUSTOMER ADDRESS INDEXES';
PRINT '=============================================';
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name='IX_CustomerAddress_CustomerID'
      AND object_id=OBJECT_ID('Customer.CustomerAddress')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_CustomerAddress_CustomerID
    ON Customer.CustomerAddress(CustomerID);
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name='IX_CustomerAddress_CountryID'
      AND object_id=OBJECT_ID('Customer.CustomerAddress')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_CustomerAddress_CountryID
    ON Customer.CustomerAddress(CountryID);
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name='IX_CustomerAddress_AddressType'
      AND object_id=OBJECT_ID('Customer.CustomerAddress')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_CustomerAddress_AddressType
    ON Customer.CustomerAddress(AddressType);
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name='IX_CustomerAddress_IsPrimary'
      AND object_id=OBJECT_ID('Customer.CustomerAddress')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_CustomerAddress_IsPrimary
    ON Customer.CustomerAddress(IsPrimary);
END
GO

PRINT 'CustomerAddress indexes created successfully.';
GO


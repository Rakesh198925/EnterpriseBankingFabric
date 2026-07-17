/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer Management
Script     : 06_Create_CustomerAddress_ForeignKeys.sql
Author     : Rakesh Soma
Purpose    : Create foreign keys for Customer.CustomerAddress
******************************************************************************/

USE BankingERP;
GO

PRINT '=============================================';
PRINT 'CREATING CUSTOMER ADDRESS FOREIGN KEYS';
PRINT '=============================================';
GO

IF NOT EXISTS (
SELECT 1
FROM sys.foreign_keys
WHERE name='FK_CustomerAddress_Customer'
)
BEGIN
ALTER TABLE Customer.CustomerAddress
ADD CONSTRAINT FK_CustomerAddress_Customer
FOREIGN KEY(CustomerID)
REFERENCES Customer.Customer(CustomerID);
END
GO

IF NOT EXISTS (
SELECT 1
FROM sys.foreign_keys
WHERE name='FK_CustomerAddress_Country'
)
BEGIN
ALTER TABLE Customer.CustomerAddress
ADD CONSTRAINT FK_CustomerAddress_Country
FOREIGN KEY(CountryID)
REFERENCES Master.CountryMaster(CountryID);
END
GO

PRINT 'CustomerAddress foreign keys created successfully.';
GO
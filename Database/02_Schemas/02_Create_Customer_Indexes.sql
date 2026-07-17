/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer Management
Script     : 02_Create_Customer_Indexes.sql
Author     : Rakesh Soma
Purpose    : Create indexes for Customer.Customer
******************************************************************************/

USE BankingERP;
GO

PRINT '=============================================';
PRINT 'CREATING CUSTOMER INDEXES';
PRINT '=============================================';
GO

---------------------------------------------------------
-- Customer Number
---------------------------------------------------------
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Customer_CustomerNumber'
      AND object_id = OBJECT_ID('Customer.Customer')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Customer_CustomerNumber
    ON Customer.Customer(CustomerNumber);
END
GO

---------------------------------------------------------
-- Customer Name
---------------------------------------------------------
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Customer_Name'
      AND object_id = OBJECT_ID('Customer.Customer')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Customer_Name
    ON Customer.Customer(LastName, FirstName);
END
GO

---------------------------------------------------------
-- Customer Type
---------------------------------------------------------
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Customer_CustomerType'
      AND object_id = OBJECT_ID('Customer.Customer')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Customer_CustomerType
    ON Customer.Customer(CustomerTypeID);
END
GO

---------------------------------------------------------
-- Branch
---------------------------------------------------------
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Customer_Branch'
      AND object_id = OBJECT_ID('Customer.Customer')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Customer_Branch
    ON Customer.Customer(BranchID);
END
GO

---------------------------------------------------------
-- Risk Category
---------------------------------------------------------
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Customer_RiskCategory'
      AND object_id = OBJECT_ID('Customer.Customer')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Customer_RiskCategory
    ON Customer.Customer(RiskCategoryID);
END
GO

---------------------------------------------------------
-- Occupation
---------------------------------------------------------
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Customer_Occupation'
      AND object_id = OBJECT_ID('Customer.Customer')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Customer_Occupation
    ON Customer.Customer(OccupationID);
END
GO

---------------------------------------------------------
-- Active Customers
---------------------------------------------------------
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Customer_IsActive'
      AND object_id = OBJECT_ID('Customer.Customer')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Customer_IsActive
    ON Customer.Customer(IsActive);
END
GO

PRINT '=============================================';
PRINT 'CUSTOMER INDEXES CREATED SUCCESSFULLY';
PRINT '=============================================';
GO
/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer Management
Script     : 03_Create_Customer_ForeignKeys.sql
Author     : Rakesh Soma
Purpose    : Create Foreign Keys for Customer.Customer
******************************************************************************/

USE BankingERP;
GO

PRINT '=============================================';
PRINT 'CREATING CUSTOMER FOREIGN KEYS';
PRINT '=============================================';
GO

---------------------------------------------------------
-- Customer Type
---------------------------------------------------------
IF NOT EXISTS
(
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_Customer_CustomerType'
)
BEGIN
    ALTER TABLE Customer.Customer
    ADD CONSTRAINT FK_Customer_CustomerType
        FOREIGN KEY (CustomerTypeID)
        REFERENCES Master.CustomerTypeMaster(CustomerTypeID);
END
GO

---------------------------------------------------------
-- Branch
---------------------------------------------------------
IF NOT EXISTS
(
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_Customer_Branch'
)
BEGIN
    ALTER TABLE Customer.Customer
    ADD CONSTRAINT FK_Customer_Branch
        FOREIGN KEY (BranchID)
        REFERENCES Master.BranchMaster(BranchID);
END
GO

---------------------------------------------------------
-- Risk Category
---------------------------------------------------------
IF NOT EXISTS
(
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_Customer_RiskCategory'
)
BEGIN
    ALTER TABLE Customer.Customer
    ADD CONSTRAINT FK_Customer_RiskCategory
        FOREIGN KEY (RiskCategoryID)
        REFERENCES Master.RiskCategoryMaster(RiskCategoryID);
END
GO

---------------------------------------------------------
-- Occupation
---------------------------------------------------------
IF NOT EXISTS
(
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_Customer_Occupation'
)
BEGIN
    ALTER TABLE Customer.Customer
    ADD CONSTRAINT FK_Customer_Occupation
        FOREIGN KEY (OccupationID)
        REFERENCES Master.OccupationMaster(OccupationID);
END
GO

---------------------------------------------------------
-- Nationality Country
---------------------------------------------------------
IF NOT EXISTS
(
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_Customer_NationalityCountry'
)
BEGIN
    ALTER TABLE Customer.Customer
    ADD CONSTRAINT FK_Customer_NationalityCountry
        FOREIGN KEY (NationalityCountryID)
        REFERENCES Master.CountryMaster(CountryID);
END
GO

---------------------------------------------------------
-- Residence Country
---------------------------------------------------------
IF NOT EXISTS
(
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_Customer_ResidenceCountry'
)
BEGIN
    ALTER TABLE Customer.Customer
    ADD CONSTRAINT FK_Customer_ResidenceCountry
        FOREIGN KEY (ResidenceCountryID)
        REFERENCES Master.CountryMaster(CountryID);
END
GO

PRINT '=============================================';
PRINT 'CUSTOMER FOREIGN KEYS CREATED SUCCESSFULLY';
PRINT '=============================================';
GO
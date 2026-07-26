/******************************************************************************
Project    : Enterprise Banking Data Platform
Script     : 01_Replace_PAN_With_NationalIdentificationNumber.sql
Purpose    : Replace PANNumber with NationalIdentificationNumber
******************************************************************************/

USE BankingERP;
GO

IF COL_LENGTH('Customer.Customer', 'PANNumber') IS NOT NULL
BEGIN
    ALTER TABLE Customer.Customer
    DROP COLUMN PANNumber;

    PRINT 'PANNumber column removed.';
END
GO

IF COL_LENGTH('Customer.Customer', 'NationalIdentificationNumber') IS NULL
BEGIN
    ALTER TABLE Customer.Customer
    ADD NationalIdentificationNumber VARCHAR(50) NULL;

    PRINT 'NationalIdentificationNumber column added.';
END
GO
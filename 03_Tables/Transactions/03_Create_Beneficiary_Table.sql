/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Transactions
Script     : 03_Create_Beneficiary_Table.sql
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Transactions.Beneficiary','U') IS NULL
BEGIN

CREATE TABLE Transactions.Beneficiary
(
    BeneficiaryID INT IDENTITY(1,1)
        CONSTRAINT PK_Beneficiary PRIMARY KEY,

    CustomerID INT NOT NULL,

    BeneficiaryName NVARCHAR(200) NOT NULL,

    IBAN VARCHAR(34) NOT NULL,

    BIC VARCHAR(11) NULL,

    BankName NVARCHAR(200),

    BankCountryID INT NOT NULL,

    BeneficiaryType VARCHAR(30),

    IsTrusted BIT DEFAULT 0,

    IsActive BIT DEFAULT 1,

    CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_Beneficiary_Customer
        FOREIGN KEY(CustomerID)
        REFERENCES Customer.Customer(CustomerID),

    CONSTRAINT FK_Beneficiary_Country
        FOREIGN KEY(BankCountryID)
        REFERENCES Master.CountryMaster(CountryID)

);

END
GO
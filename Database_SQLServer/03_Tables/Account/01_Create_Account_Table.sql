/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Account
Script     : 01_Create_Account_Table.sql
Author     : Rakesh Soma
Purpose    : Create Account table
******************************************************************************/

USE BankingERP;
GO

PRINT '=============================================';
PRINT 'CREATING ACCOUNT.ACCOUNT TABLE';
PRINT '=============================================';
GO

IF OBJECT_ID('Account.Account','U') IS NULL
BEGIN

CREATE TABLE Account.Account
(
    AccountID INT IDENTITY(100000,1)
        CONSTRAINT PK_Account PRIMARY KEY,

    AccountNumber VARCHAR(34) NOT NULL
        CONSTRAINT UQ_Account_Number UNIQUE,

    IBAN VARCHAR(34) NULL
        CONSTRAINT UQ_Account_IBAN UNIQUE,

    AccountName NVARCHAR(200) NOT NULL,

    CustomerID INT NOT NULL,

    BranchID INT NOT NULL,

    AccountTypeID INT NOT NULL,

    CurrencyID INT NOT NULL,

    OpenDate DATE NOT NULL,

    CloseDate DATE NULL,

    AccountStatus VARCHAR(30) NOT NULL
        DEFAULT 'Active',

    AvailableBalance DECIMAL(18,2) NOT NULL
        DEFAULT 0,

    CurrentBalance DECIMAL(18,2) NOT NULL
        DEFAULT 0,

    OverdraftLimit DECIMAL(18,2) NOT NULL
        DEFAULT 0,

    IsJointAccount BIT NOT NULL
        DEFAULT 0,

    IsActive BIT NOT NULL
        DEFAULT 1,

    CreatedDate DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    CreatedBy NVARCHAR(100) NOT NULL
        DEFAULT SUSER_SNAME(),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy NVARCHAR(100) NULL,

    CONSTRAINT FK_Account_Customer
        FOREIGN KEY(CustomerID)
        REFERENCES Customer.Customer(CustomerID),

    CONSTRAINT FK_Account_Branch
        FOREIGN KEY(BranchID)
        REFERENCES Master.BranchMaster(BranchID),

    CONSTRAINT FK_Account_AccountType
        FOREIGN KEY(AccountTypeID)
        REFERENCES Master.AccountTypeMaster(AccountTypeID),

    CONSTRAINT FK_Account_Currency
        FOREIGN KEY(CurrencyID)
        REFERENCES Master.CurrencyMaster(CurrencyID)
);

END
GO

PRINT 'Account table created successfully';
GO
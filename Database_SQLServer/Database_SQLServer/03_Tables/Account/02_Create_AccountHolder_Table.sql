/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Account
Script     : 02_Create_AccountHolder_Table.sql
Author     : Rakesh Soma
Purpose    : Create Account Holder table
******************************************************************************/

USE BankingERP;
GO

PRINT '=============================================';
PRINT 'CREATING ACCOUNT.ACCOUNTHOLDER TABLE';
PRINT '=============================================';
GO

IF OBJECT_ID('Account.AccountHolder','U') IS NULL
BEGIN

CREATE TABLE Account.AccountHolder
(
    AccountHolderID INT IDENTITY(1,1)
        CONSTRAINT PK_AccountHolder PRIMARY KEY,

    AccountID INT NOT NULL,

    CustomerID INT NOT NULL,

    HolderType VARCHAR(30) NOT NULL,
        -- Primary
        -- Joint
        -- Authorized Signatory
        -- Power of Attorney

    OwnershipPercentage DECIMAL(5,2) NULL,

    StartDate DATE NOT NULL,

    EndDate DATE NULL,

    IsPrimaryHolder BIT NOT NULL DEFAULT 0,

    IsActive BIT NOT NULL DEFAULT 1,

    CreatedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SUSER_SNAME(),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy NVARCHAR(100) NULL,

    CONSTRAINT FK_AccountHolder_Account
        FOREIGN KEY(AccountID)
        REFERENCES Account.Account(AccountID),

    CONSTRAINT FK_AccountHolder_Customer
        FOREIGN KEY(CustomerID)
        REFERENCES Customer.Customer(CustomerID)
);

END
GO
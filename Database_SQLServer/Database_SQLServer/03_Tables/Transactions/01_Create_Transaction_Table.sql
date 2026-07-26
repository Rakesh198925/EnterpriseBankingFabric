/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Transactions
Script     : 01_Create_Transaction_Table.sql
Author     : Rakesh Soma
Purpose    : Create Transaction table
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Transactions.[Transaction]','U') IS NULL
BEGIN

CREATE TABLE Transactions.[Transaction]
(
    TransactionID BIGINT IDENTITY(1,1)
        CONSTRAINT PK_Transaction PRIMARY KEY,

    TransactionReference VARCHAR(50) NOT NULL
        CONSTRAINT UQ_TransactionReference UNIQUE,

    AccountID INT NOT NULL,

    TransactionTypeID INT NOT NULL,

    TransactionDate DATETIME2 NOT NULL,

    ValueDate DATE NOT NULL,

    Amount DECIMAL(18,2) NOT NULL,

    CurrencyID INT NOT NULL,

    DebitCreditIndicator CHAR(1) NOT NULL,

    TransactionStatus VARCHAR(30) NOT NULL,

    Channel VARCHAR(30) NULL,
        -- Branch, Mobile, ATM, Online Banking, API

    Description NVARCHAR(500) NULL,

    CreatedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SUSER_SNAME(),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy NVARCHAR(100) NULL,

    CONSTRAINT FK_Transaction_Account
        FOREIGN KEY(AccountID)
        REFERENCES Account.Account(AccountID),

    CONSTRAINT FK_Transaction_Type
        FOREIGN KEY(TransactionTypeID)
        REFERENCES Master.TransactionTypeMaster(TransactionTypeID),

    CONSTRAINT FK_Transaction_Currency
        FOREIGN KEY(CurrencyID)
        REFERENCES Master.CurrencyMaster(CurrencyID)
);

END
GO
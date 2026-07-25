/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Account
Script     : 03_Create_AccountBalance_Table.sql
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Account.AccountBalance','U') IS NULL
BEGIN

CREATE TABLE Account.AccountBalance
(
    AccountBalanceID BIGINT IDENTITY(1,1)
        CONSTRAINT PK_AccountBalance PRIMARY KEY,

    AccountID INT NOT NULL,

    BalanceDate DATE NOT NULL,

    OpeningBalance DECIMAL(18,2) NOT NULL,

    TotalCredits DECIMAL(18,2) NOT NULL DEFAULT 0,

    TotalDebits DECIMAL(18,2) NOT NULL DEFAULT 0,

    ClosingBalance DECIMAL(18,2) NOT NULL,

    AvailableBalance DECIMAL(18,2) NOT NULL,

    LedgerBalance DECIMAL(18,2) NOT NULL,

    CreatedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_AccountBalance_Account
        FOREIGN KEY(AccountID)
        REFERENCES Account.Account(AccountID)
);

END
GO
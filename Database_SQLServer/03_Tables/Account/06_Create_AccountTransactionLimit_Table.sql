/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Account
Script     : 06_Create_AccountTransactionLimit_Table.sql
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Account.AccountTransactionLimit','U') IS NULL
BEGIN

CREATE TABLE Account.AccountTransactionLimit
(
    AccountTransactionLimitID INT IDENTITY(1,1)
        CONSTRAINT PK_AccountTransactionLimit PRIMARY KEY,

    AccountID INT NOT NULL,

    DailyATMWithdrawalLimit DECIMAL(18,2),

    DailyPOSLimit DECIMAL(18,2),

    DailyOnlineTransferLimit DECIMAL(18,2),

    DailyCashDepositLimit DECIMAL(18,2),

    CurrencyCode CHAR(3),

    EffectiveFrom DATE,

    EffectiveTo DATE,

    CreatedDate DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_AccountTransactionLimit_Account
        FOREIGN KEY(AccountID)
        REFERENCES Account.Account(AccountID)
);

END
GO
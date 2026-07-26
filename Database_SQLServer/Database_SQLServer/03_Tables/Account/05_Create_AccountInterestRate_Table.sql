/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Account
Script     : 05_Create_AccountInterestRate_Table.sql
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Account.AccountInterestRate','U') IS NULL
BEGIN

CREATE TABLE Account.AccountInterestRate
(
    AccountInterestRateID INT IDENTITY(1,1)
        CONSTRAINT PK_AccountInterestRate PRIMARY KEY,

    AccountID INT NOT NULL,

    InterestRate DECIMAL(6,3) NOT NULL,

    RateType VARCHAR(20) NOT NULL,

    EffectiveFrom DATE NOT NULL,

    EffectiveTo DATE NULL,

    CreatedDate DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_AccountInterestRate_Account
        FOREIGN KEY(AccountID)
        REFERENCES Account.Account(AccountID)
);

END
GO
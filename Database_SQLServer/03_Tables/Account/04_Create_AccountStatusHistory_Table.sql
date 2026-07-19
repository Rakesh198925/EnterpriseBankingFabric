/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Account
Script     : 04_Create_AccountStatusHistory_Table.sql
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Account.AccountStatusHistory','U') IS NULL
BEGIN

CREATE TABLE Account.AccountStatusHistory
(
    AccountStatusHistoryID BIGINT IDENTITY(1,1)
        CONSTRAINT PK_AccountStatusHistory PRIMARY KEY,

    AccountID INT NOT NULL,

    PreviousStatus VARCHAR(30),

    CurrentStatus VARCHAR(30) NOT NULL,

    StatusReason NVARCHAR(250),

    EffectiveFrom DATETIME2 NOT NULL,

    EffectiveTo DATETIME2 NULL,

    ChangedBy NVARCHAR(100),

    CreatedDate DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_AccountStatusHistory_Account
        FOREIGN KEY(AccountID)
        REFERENCES Account.Account(AccountID)
);

END
GO
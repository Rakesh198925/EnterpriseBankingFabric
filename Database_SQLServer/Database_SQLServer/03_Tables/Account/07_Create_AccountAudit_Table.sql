/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Account
Script     : 07_Create_AccountAudit_Table.sql
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Account.AccountAudit','U') IS NULL
BEGIN

CREATE TABLE Account.AccountAudit
(
    AccountAuditID BIGINT IDENTITY(1,1)
        CONSTRAINT PK_AccountAudit PRIMARY KEY,

    AccountID INT NOT NULL,

    AuditAction VARCHAR(30) NOT NULL,

    ChangedColumn NVARCHAR(100),

    OldValue NVARCHAR(1000),

    NewValue NVARCHAR(1000),

    ChangedBy NVARCHAR(100),

    ChangedDate DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    SourceSystem VARCHAR(50)
        DEFAULT 'SQL Server',

    CONSTRAINT FK_AccountAudit_Account
        FOREIGN KEY(AccountID)
        REFERENCES Account.Account(AccountID)
);

END
GO



-----------Validate the Account Module----------

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'Account'
ORDER BY TABLE_NAME;
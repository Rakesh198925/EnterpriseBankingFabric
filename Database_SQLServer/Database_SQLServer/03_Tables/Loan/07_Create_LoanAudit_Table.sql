/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Loan
Script     : 07_Create_LoanAudit_Table.sql
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Loan.LoanAudit','U') IS NULL
BEGIN

CREATE TABLE Loan.LoanAudit
(
    LoanAuditID BIGINT IDENTITY(1,1)
        CONSTRAINT PK_LoanAudit PRIMARY KEY,

    LoanID INT NOT NULL,

    AuditAction VARCHAR(30),

    ChangedColumn NVARCHAR(100),

    OldValue NVARCHAR(1000),

    NewValue NVARCHAR(1000),

    ChangedBy NVARCHAR(100),

    ChangedDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    SourceSystem VARCHAR(50) DEFAULT 'SQL Server',

    CONSTRAINT FK_LoanAudit_Loan
        FOREIGN KEY(LoanID)
        REFERENCES Loan.Loan(LoanID)

);

END
GO



------------Validate Loan Module------------

USE BankingERP;
GO

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'Loan'
ORDER BY TABLE_NAME;
USE BankingERP;
GO

IF OBJECT_ID('Transactions.TransactionAudit','U') IS NULL
BEGIN

CREATE TABLE Transactions.TransactionAudit
(
    TransactionAuditID BIGINT IDENTITY PRIMARY KEY,

    TransactionID BIGINT NOT NULL,

    AuditAction VARCHAR(30),

    PreviousStatus VARCHAR(30),

    CurrentStatus VARCHAR(30),

    ChangedBy NVARCHAR(100),

    ChangedDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    SourceSystem VARCHAR(50) DEFAULT 'SQL Server',

    CONSTRAINT FK_TransactionAudit_Transaction
        FOREIGN KEY(TransactionID)
        REFERENCES Transactions.[Transaction](TransactionID)

);

END
GO
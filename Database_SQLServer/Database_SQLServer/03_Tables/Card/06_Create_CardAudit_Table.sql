USE BankingERP;
GO

IF OBJECT_ID('Card.CardAudit','U') IS NULL
BEGIN

CREATE TABLE Card.CardAudit
(
    CardAuditID BIGINT IDENTITY PRIMARY KEY,

    CardID INT NOT NULL,

    AuditAction VARCHAR(30),

    ChangedColumn NVARCHAR(100),

    OldValue NVARCHAR(1000),

    NewValue NVARCHAR(1000),

    ChangedBy NVARCHAR(100),

    ChangedDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    SourceSystem VARCHAR(50) DEFAULT 'SQL Server',

    CONSTRAINT FK_CardAudit_Card
        FOREIGN KEY(CardID)
        REFERENCES Card.Card(CardID)

);

END
GO
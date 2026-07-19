USE BankingERP;
GO

IF OBJECT_ID('Card.CardPINHistory','U') IS NULL
BEGIN

CREATE TABLE Card.CardPINHistory
(
    CardPINHistoryID BIGINT IDENTITY PRIMARY KEY,

    CardID INT NOT NULL,

    PINChangedDate DATETIME2 NOT NULL,

    ChangedBy NVARCHAR(100),

    ChangeChannel VARCHAR(30),

    CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_PINHistory_Card
        FOREIGN KEY(CardID)
        REFERENCES Card.Card(CardID)

);

END
GO
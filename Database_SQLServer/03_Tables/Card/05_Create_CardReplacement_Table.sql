USE BankingERP;
GO

IF OBJECT_ID('Card.CardReplacement','U') IS NULL
BEGIN

CREATE TABLE Card.CardReplacement
(
    CardReplacementID INT IDENTITY PRIMARY KEY,

    OldCardID INT NOT NULL,

    NewCardID INT NOT NULL,

    ReplacementReason VARCHAR(50),

    ReplacementDate DATE,

    RequestedBy NVARCHAR(100),

    CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_CR_OldCard
        FOREIGN KEY(OldCardID)
        REFERENCES Card.Card(CardID),

    CONSTRAINT FK_CR_NewCard
        FOREIGN KEY(NewCardID)
        REFERENCES Card.Card(CardID)

);

END
GO
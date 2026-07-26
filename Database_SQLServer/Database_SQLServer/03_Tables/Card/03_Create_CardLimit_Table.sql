USE BankingERP;
GO

IF OBJECT_ID('Card.CardLimit','U') IS NULL
BEGIN

CREATE TABLE Card.CardLimit
(
    CardLimitID INT IDENTITY PRIMARY KEY,

    CardID INT NOT NULL,

    DailyATMWithdrawalLimit DECIMAL(18,2),

    DailyPOSLimit DECIMAL(18,2),

    DailyOnlineLimit DECIMAL(18,2),

    ContactlessLimit DECIMAL(18,2),

    CurrencyID INT,

    EffectiveFrom DATE,

    EffectiveTo DATE,

    CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_CardLimit_Card
        FOREIGN KEY(CardID)
        REFERENCES Card.Card(CardID),

    CONSTRAINT FK_CardLimit_Currency
        FOREIGN KEY(CurrencyID)
        REFERENCES Master.CurrencyMaster(CurrencyID)

);

END
GO
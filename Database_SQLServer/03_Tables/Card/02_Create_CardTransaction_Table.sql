USE BankingERP;
GO

IF OBJECT_ID('Card.CardTransaction','U') IS NULL
BEGIN

CREATE TABLE Card.CardTransaction
(
    CardTransactionID BIGINT IDENTITY PRIMARY KEY,

    CardID INT NOT NULL,

    TransactionID BIGINT NULL,

    MerchantName NVARCHAR(200),

    MerchantCountryID INT,

    MerchantCategoryCode VARCHAR(10),

    TransactionAmount DECIMAL(18,2),

    CurrencyID INT,

    TransactionDate DATETIME2,

    AuthorizationCode VARCHAR(50),

    CardEntryMode VARCHAR(30),

    TransactionStatus VARCHAR(30),

    CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_CT_Card
        FOREIGN KEY(CardID)
        REFERENCES Card.Card(CardID),

    CONSTRAINT FK_CT_Transaction
        FOREIGN KEY(TransactionID)
        REFERENCES Transactions.[Transaction](TransactionID),

    CONSTRAINT FK_CT_Currency
        FOREIGN KEY(CurrencyID)
        REFERENCES Master.CurrencyMaster(CurrencyID),

    CONSTRAINT FK_CT_Country
        FOREIGN KEY(MerchantCountryID)
        REFERENCES Master.CountryMaster(CountryID)

);

END
GO
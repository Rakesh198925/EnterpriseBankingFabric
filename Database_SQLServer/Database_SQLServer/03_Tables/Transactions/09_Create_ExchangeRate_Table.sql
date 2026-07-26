USE BankingERP;
GO

IF OBJECT_ID('Transactions.ExchangeRate','U') IS NULL
BEGIN

CREATE TABLE Transactions.ExchangeRate
(
    ExchangeRateID INT IDENTITY PRIMARY KEY,

    FromCurrencyID INT NOT NULL,

    ToCurrencyID INT NOT NULL,

    ExchangeRate DECIMAL(18,8) NOT NULL,

    EffectiveDate DATE NOT NULL,

    CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_ExchangeRate_FromCurrency
        FOREIGN KEY(FromCurrencyID)
        REFERENCES Master.CurrencyMaster(CurrencyID),

    CONSTRAINT FK_ExchangeRate_ToCurrency
        FOREIGN KEY(ToCurrencyID)
        REFERENCES Master.CurrencyMaster(CurrencyID)
);

END
GO


-----------Validate the Transactions Module--------


SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'Transactions'
ORDER BY TABLE_NAME;
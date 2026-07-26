USE BankingERP;
GO

IF OBJECT_ID('Transactions.TransactionFee','U') IS NULL
BEGIN

CREATE TABLE Transactions.TransactionFee
(
    TransactionFeeID BIGINT IDENTITY PRIMARY KEY,

    TransactionID BIGINT NOT NULL,

    FeeType VARCHAR(50),

    FeeAmount DECIMAL(18,2),

    CurrencyID INT,

    CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_Fee_Transaction
        FOREIGN KEY(TransactionID)
        REFERENCES Transactions.[Transaction](TransactionID),

    CONSTRAINT FK_Fee_Currency
        FOREIGN KEY(CurrencyID)
        REFERENCES Master.CurrencyMaster(CurrencyID)

);

END
GO
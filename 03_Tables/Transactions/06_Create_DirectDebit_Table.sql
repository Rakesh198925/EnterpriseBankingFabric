USE BankingERP;
GO

IF OBJECT_ID('Transactions.DirectDebit','U') IS NULL
BEGIN

CREATE TABLE Transactions.DirectDebit
(
    DirectDebitID INT IDENTITY PRIMARY KEY,

    AccountID INT NOT NULL,

    CreditorName NVARCHAR(200),

    CreditorIdentifier VARCHAR(100),

    MandateReference VARCHAR(100),

    CollectionFrequency VARCHAR(20),

    Amount DECIMAL(18,2),

    Status VARCHAR(20),

    CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_DD_Account
        FOREIGN KEY(AccountID)
        REFERENCES Account.Account(AccountID)

);

END
GO
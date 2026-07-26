USE BankingERP;
GO

IF OBJECT_ID('Card.CardAuthorization','U') IS NULL
BEGIN

CREATE TABLE Card.CardAuthorization
(
    CardAuthorizationID BIGINT IDENTITY PRIMARY KEY,

    CardID INT NOT NULL,

    AuthorizationCode VARCHAR(50) NOT NULL,

    MerchantName NVARCHAR(200),

    AuthorizationAmount DECIMAL(18,2),

    CurrencyID INT,

    AuthorizationStatus VARCHAR(30),

    AuthorizationDate DATETIME2,

    ExpiryDate DATETIME2 NULL,

    CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_CardAuthorization_Card
        FOREIGN KEY(CardID)
        REFERENCES Card.Card(CardID),

    CONSTRAINT FK_CardAuthorization_Currency
        FOREIGN KEY(CurrencyID)
        REFERENCES Master.CurrencyMaster(CurrencyID)

);

END
GO

------------Validate Card Module-----------


USE BankingERP;
GO

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA='Card'
ORDER BY TABLE_NAME;
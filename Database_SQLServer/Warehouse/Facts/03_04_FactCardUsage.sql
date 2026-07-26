/*==============================================================================
 Project      : Enterprise Banking Fabric
 Layer        : Enterprise Data Warehouse
 Script Name  : 03_04_FactCardUsage.sql
 Author       : Rakesh Soma
 Description  : Creates Enterprise Card Usage Fact Table
==============================================================================*/

USE BankingERP;
GO

/*==============================================================
 Drop Existing Table
==============================================================*/

IF OBJECT_ID('Fact.FactCardUsage','U') IS NOT NULL
BEGIN
    DROP TABLE Fact.FactCardUsage;
END
GO

/*==============================================================
 Create FactCardUsage
==============================================================*/

CREATE TABLE Fact.FactCardUsage
(
    ----------------------------------------------------------
    -- Fact Key
    ----------------------------------------------------------
    CardUsageKey BIGINT IDENTITY(1,1) NOT NULL,

    ----------------------------------------------------------
    -- Business Key
    ----------------------------------------------------------
    CardTransactionID BIGINT NOT NULL,

    ----------------------------------------------------------
    -- Dimension Keys
    ----------------------------------------------------------
    CardKey BIGINT NOT NULL,

    CustomerKey BIGINT NOT NULL,

    AccountKey BIGINT NOT NULL,

    BranchKey BIGINT NOT NULL,

    CurrencyKey BIGINT NOT NULL,

    DateKey INT NOT NULL,

    TimeKey INT NOT NULL,

    ----------------------------------------------------------
    -- Transaction Details
    ----------------------------------------------------------
    MerchantName NVARCHAR(200),

    MerchantCategory VARCHAR(100),

    TerminalID VARCHAR(50),

    CardChannel VARCHAR(30),

    TransactionType VARCHAR(50),

    TransactionStatus VARCHAR(30),

    ----------------------------------------------------------
    -- Financial Measures
    ----------------------------------------------------------
    TransactionAmount DECIMAL(18,2) NOT NULL,

    CashbackAmount DECIMAL(18,2) DEFAULT(0),

    FeeAmount DECIMAL(18,2) DEFAULT(0),

    TaxAmount DECIMAL(18,2) DEFAULT(0),

    ExchangeRate DECIMAL(18,8) DEFAULT(1),

    ----------------------------------------------------------
    -- Fraud Indicators
    ----------------------------------------------------------
    IsInternational BIT DEFAULT(0),

    IsContactless BIT DEFAULT(0),

    IsOnline BIT DEFAULT(0),

    IsATMWithdrawal BIT DEFAULT(0),

    IsFraudSuspected BIT DEFAULT(0),

    ----------------------------------------------------------
    -- Audit
    ----------------------------------------------------------
    SourceSystem VARCHAR(50),

    ETLBatchID UNIQUEIDENTIFIER,

    LoadDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    ----------------------------------------------------------
    -- Constraints
    ----------------------------------------------------------
    CONSTRAINT PK_FactCardUsage
        PRIMARY KEY CLUSTERED(CardUsageKey),

    CONSTRAINT FK_FCU_Card
        FOREIGN KEY(CardKey)
        REFERENCES Dim.DimCard(CardKey),

    CONSTRAINT FK_FCU_Customer
        FOREIGN KEY(CustomerKey)
        REFERENCES Dim.DimCustomer(CustomerKey),

    CONSTRAINT FK_FCU_Account
        FOREIGN KEY(AccountKey)
        REFERENCES Dim.DimAccount(AccountKey),

    CONSTRAINT FK_FCU_Branch
        FOREIGN KEY(BranchKey)
        REFERENCES Dim.DimBranch(BranchKey),

    CONSTRAINT FK_FCU_Currency
        FOREIGN KEY(CurrencyKey)
        REFERENCES Dim.DimCurrency(CurrencyKey),

    CONSTRAINT FK_FCU_Date
        FOREIGN KEY(DateKey)
        REFERENCES Dim.DimDate(DateKey),

    CONSTRAINT FK_FCU_Time
        FOREIGN KEY(TimeKey)
        REFERENCES Dim.DimTime(TimeKey)
);
GO

/*==============================================================
 Indexes
==============================================================*/

CREATE NONCLUSTERED INDEX IX_FCU_DateKey
ON Fact.FactCardUsage(DateKey);
GO

CREATE NONCLUSTERED INDEX IX_FCU_CardKey
ON Fact.FactCardUsage(CardKey);
GO

CREATE NONCLUSTERED INDEX IX_FCU_CustomerKey
ON Fact.FactCardUsage(CustomerKey);
GO

CREATE NONCLUSTERED INDEX IX_FCU_Fraud
ON Fact.FactCardUsage(IsFraudSuspected);
GO

CREATE NONCLUSTERED INDEX IX_FCU_International
ON Fact.FactCardUsage(IsInternational);
GO

/*==============================================================
 Validation
==============================================================*/

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA='Fact'
AND TABLE_NAME='FactCardUsage';
GO

PRINT 'FactCardUsage Created Successfully';
GO
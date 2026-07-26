/*==============================================================================
 Project      : Enterprise Banking Fabric
 Layer        : Enterprise Data Warehouse
 Script Name  : 03_01_FactTransaction.sql
 Author       : Rakesh Soma
 Description  : Creates Enterprise Banking Transaction Fact Table
==============================================================================*/

USE BankingERP;
GO

/*==============================================================
 Drop Existing Table
==============================================================*/

IF OBJECT_ID('Fact.FactTransaction','U') IS NOT NULL
BEGIN
    DROP TABLE Fact.FactTransaction;
END
GO

/*==============================================================
 Create FactTransaction
==============================================================*/

CREATE TABLE Fact.FactTransaction
(
    ----------------------------------------------------------
    -- Fact Key
    ----------------------------------------------------------
    TransactionKey BIGINT IDENTITY(1,1) NOT NULL,

    ----------------------------------------------------------
    -- Business Keys
    ----------------------------------------------------------
    TransactionID BIGINT NOT NULL,

    TransactionNumber VARCHAR(50) NOT NULL,

    ----------------------------------------------------------
    -- Dimension Keys
    ----------------------------------------------------------
    CustomerKey BIGINT NOT NULL,

    AccountKey BIGINT NOT NULL,

    BranchKey BIGINT NOT NULL,

    CurrencyKey BIGINT NOT NULL,

    DateKey INT NOT NULL,

    TimeKey INT NOT NULL,

    ----------------------------------------------------------
    -- Transaction Attributes
    ----------------------------------------------------------
    TransactionType VARCHAR(50),

    TransactionChannel VARCHAR(50),

    PaymentMethod VARCHAR(50),

    TransactionStatus VARCHAR(30),

    ReferenceNumber VARCHAR(100),

    Narration NVARCHAR(500),

    ----------------------------------------------------------
    -- Financial Measures
    ----------------------------------------------------------
    TransactionAmount DECIMAL(18,2) NOT NULL,

    DebitAmount DECIMAL(18,2) DEFAULT(0),

    CreditAmount DECIMAL(18,2) DEFAULT(0),

    FeeAmount DECIMAL(18,2) DEFAULT(0),

    TaxAmount DECIMAL(18,2) DEFAULT(0),

    ExchangeRate DECIMAL(18,8) DEFAULT(1),

    BalanceAfterTransaction DECIMAL(18,2),

    ----------------------------------------------------------
    -- Audit Columns
    ----------------------------------------------------------
    SourceSystem VARCHAR(50),

    ETLBatchID UNIQUEIDENTIFIER,

    LoadDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    ----------------------------------------------------------
    -- Constraints
    ----------------------------------------------------------
    CONSTRAINT PK_FactTransaction
        PRIMARY KEY CLUSTERED(TransactionKey),

    CONSTRAINT FK_FactTransaction_Customer
        FOREIGN KEY(CustomerKey)
        REFERENCES Dim.DimCustomer(CustomerKey),

    CONSTRAINT FK_FactTransaction_Account
        FOREIGN KEY(AccountKey)
        REFERENCES Dim.DimAccount(AccountKey),

    CONSTRAINT FK_FactTransaction_Branch
        FOREIGN KEY(BranchKey)
        REFERENCES Dim.DimBranch(BranchKey),

    CONSTRAINT FK_FactTransaction_Currency
        FOREIGN KEY(CurrencyKey)
        REFERENCES Dim.DimCurrency(CurrencyKey),

    CONSTRAINT FK_FactTransaction_Date
        FOREIGN KEY(DateKey)
        REFERENCES Dim.DimDate(DateKey),

    CONSTRAINT FK_FactTransaction_Time
        FOREIGN KEY(TimeKey)
        REFERENCES Dim.DimTime(TimeKey)
);
GO

/*==============================================================
 Indexes
==============================================================*/

CREATE NONCLUSTERED INDEX IX_FactTransaction_DateKey
ON Fact.FactTransaction(DateKey);
GO

CREATE NONCLUSTERED INDEX IX_FactTransaction_AccountKey
ON Fact.FactTransaction(AccountKey);
GO

CREATE NONCLUSTERED INDEX IX_FactTransaction_CustomerKey
ON Fact.FactTransaction(CustomerKey);
GO

CREATE NONCLUSTERED INDEX IX_FactTransaction_BranchKey
ON Fact.FactTransaction(BranchKey);
GO

CREATE NONCLUSTERED INDEX IX_FactTransaction_TransactionID
ON Fact.FactTransaction(TransactionID);
GO

/*==============================================================
 Validation
==============================================================*/

SELECT
TABLE_SCHEMA,
TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA='Fact'
AND TABLE_NAME='FactTransaction';
GO

PRINT 'FactTransaction Created Successfully';
GO
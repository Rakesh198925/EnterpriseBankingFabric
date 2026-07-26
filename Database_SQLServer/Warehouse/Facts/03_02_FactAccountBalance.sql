/*==============================================================================
 Project      : Enterprise Banking Fabric
 Layer        : Enterprise Data Warehouse
 Script Name  : 03_02_FactAccountBalance.sql
 Author       : Rakesh Soma
 Description  : Creates Daily Account Balance Snapshot Fact Table
==============================================================================*/

USE BankingERP;
GO

/*==============================================================
 Drop Existing Table
==============================================================*/

IF OBJECT_ID('Fact.FactAccountBalance','U') IS NOT NULL
BEGIN
    DROP TABLE Fact.FactAccountBalance;
END
GO

/*==============================================================
 Create Fact Table
==============================================================*/

CREATE TABLE Fact.FactAccountBalance
(
    ----------------------------------------------------------
    -- Fact Key
    ----------------------------------------------------------
    AccountBalanceKey BIGINT IDENTITY(1,1) NOT NULL,

    ----------------------------------------------------------
    -- Business Key
    ----------------------------------------------------------
    BalanceSnapshotID BIGINT NOT NULL,

    ----------------------------------------------------------
    -- Dimension Keys
    ----------------------------------------------------------
    AccountKey BIGINT NOT NULL,

    CustomerKey BIGINT NOT NULL,

    BranchKey BIGINT NOT NULL,

    CurrencyKey BIGINT NOT NULL,

    DateKey INT NOT NULL,

    ----------------------------------------------------------
    -- Balance Measures
    ----------------------------------------------------------
    OpeningBalance DECIMAL(18,2) NOT NULL,

    TotalCredits DECIMAL(18,2) DEFAULT(0),

    TotalDebits DECIMAL(18,2) DEFAULT(0),

    ClosingBalance DECIMAL(18,2) NOT NULL,

    AvailableBalance DECIMAL(18,2) NOT NULL,

    HoldAmount DECIMAL(18,2) DEFAULT(0),

    InterestAccrued DECIMAL(18,2) DEFAULT(0),

    MinimumBalanceRequired DECIMAL(18,2) DEFAULT(0),

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
    CONSTRAINT PK_FactAccountBalance
        PRIMARY KEY CLUSTERED(AccountBalanceKey),

    CONSTRAINT FK_FAB_Account
        FOREIGN KEY(AccountKey)
        REFERENCES Dim.DimAccount(AccountKey),

    CONSTRAINT FK_FAB_Customer
        FOREIGN KEY(CustomerKey)
        REFERENCES Dim.DimCustomer(CustomerKey),

    CONSTRAINT FK_FAB_Branch
        FOREIGN KEY(BranchKey)
        REFERENCES Dim.DimBranch(BranchKey),

    CONSTRAINT FK_FAB_Currency
        FOREIGN KEY(CurrencyKey)
        REFERENCES Dim.DimCurrency(CurrencyKey),

    CONSTRAINT FK_FAB_Date
        FOREIGN KEY(DateKey)
        REFERENCES Dim.DimDate(DateKey)
);
GO

/*==============================================================
 Indexes
==============================================================*/

CREATE NONCLUSTERED INDEX IX_FAB_Date
ON Fact.FactAccountBalance(DateKey);
GO

CREATE NONCLUSTERED INDEX IX_FAB_Account
ON Fact.FactAccountBalance(AccountKey);
GO

CREATE NONCLUSTERED INDEX IX_FAB_Customer
ON Fact.FactAccountBalance(CustomerKey);
GO

CREATE NONCLUSTERED INDEX IX_FAB_Branch
ON Fact.FactAccountBalance(BranchKey);
GO

/*==============================================================
 Validation
==============================================================*/

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA='Fact'
AND TABLE_NAME='FactAccountBalance';
GO

PRINT 'FactAccountBalance Created Successfully';
GO
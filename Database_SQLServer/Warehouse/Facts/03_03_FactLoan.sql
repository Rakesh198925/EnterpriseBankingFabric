/*==============================================================================
 Project      : Enterprise Banking Fabric
 Layer        : Enterprise Data Warehouse
 Script Name  : 03_03_FactLoan.sql
 Author       : Rakesh Soma
 Description  : Creates Enterprise Loan Fact Table
==============================================================================*/

USE BankingERP;
GO

/*==============================================================
 Drop Existing Table
==============================================================*/

IF OBJECT_ID('Fact.FactLoan','U') IS NOT NULL
BEGIN
    DROP TABLE Fact.FactLoan;
END
GO

/*==============================================================
 Create FactLoan
==============================================================*/

CREATE TABLE Fact.FactLoan
(
    ----------------------------------------------------------
    -- Fact Key
    ----------------------------------------------------------
    LoanFactKey BIGINT IDENTITY(1,1) NOT NULL,

    ----------------------------------------------------------
    -- Business Key
    ----------------------------------------------------------
    LoanTransactionID BIGINT NOT NULL,

    ----------------------------------------------------------
    -- Dimension Keys
    ----------------------------------------------------------
    LoanKey BIGINT NOT NULL,

    CustomerKey BIGINT NOT NULL,

    AccountKey BIGINT NOT NULL,

    BranchKey BIGINT NOT NULL,

    CurrencyKey BIGINT NOT NULL,

    DateKey INT NOT NULL,

    ----------------------------------------------------------
    -- Loan Measures
    ----------------------------------------------------------
    LoanAmount DECIMAL(18,2) NOT NULL,

    OutstandingPrincipal DECIMAL(18,2) NOT NULL,

    OutstandingInterest DECIMAL(18,2) DEFAULT(0),

    EMIAmount DECIMAL(18,2) NOT NULL,

    PrincipalPaid DECIMAL(18,2) DEFAULT(0),

    InterestPaid DECIMAL(18,2) DEFAULT(0),

    OverdueAmount DECIMAL(18,2) DEFAULT(0),

    PenaltyAmount DECIMAL(18,2) DEFAULT(0),

    RemainingTenureMonths INT,

    DaysPastDue INT DEFAULT(0),

    IsNPA BIT DEFAULT(0),

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
    CONSTRAINT PK_FactLoan
        PRIMARY KEY CLUSTERED(LoanFactKey),

    CONSTRAINT FK_FL_Loan
        FOREIGN KEY(LoanKey)
        REFERENCES Dim.DimLoan(LoanKey),

    CONSTRAINT FK_FL_Customer
        FOREIGN KEY(CustomerKey)
        REFERENCES Dim.DimCustomer(CustomerKey),

    CONSTRAINT FK_FL_Account
        FOREIGN KEY(AccountKey)
        REFERENCES Dim.DimAccount(AccountKey),

    CONSTRAINT FK_FL_Branch
        FOREIGN KEY(BranchKey)
        REFERENCES Dim.DimBranch(BranchKey),

    CONSTRAINT FK_FL_Currency
        FOREIGN KEY(CurrencyKey)
        REFERENCES Dim.DimCurrency(CurrencyKey),

    CONSTRAINT FK_FL_Date
        FOREIGN KEY(DateKey)
        REFERENCES Dim.DimDate(DateKey)
);
GO

/*==============================================================
 Indexes
==============================================================*/

CREATE NONCLUSTERED INDEX IX_FactLoan_DateKey
ON Fact.FactLoan(DateKey);
GO

CREATE NONCLUSTERED INDEX IX_FactLoan_LoanKey
ON Fact.FactLoan(LoanKey);
GO

CREATE NONCLUSTERED INDEX IX_FactLoan_CustomerKey
ON Fact.FactLoan(CustomerKey);
GO

CREATE NONCLUSTERED INDEX IX_FactLoan_NPA
ON Fact.FactLoan(IsNPA);
GO

CREATE NONCLUSTERED INDEX IX_FactLoan_DPD
ON Fact.FactLoan(DaysPastDue);
GO

/*==============================================================
 Validation
==============================================================*/

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA='Fact'
AND TABLE_NAME='FactLoan';
GO

PRINT 'FactLoan Created Successfully';
GO
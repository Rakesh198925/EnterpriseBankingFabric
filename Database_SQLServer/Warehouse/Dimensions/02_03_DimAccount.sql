/*==============================================================================
 Project      : Enterprise Banking Fabric
 Layer        : Enterprise Data Warehouse
 Script Name  : 02_03_DimAccount.sql
 Author       : Rakesh Soma
 Description  : Creates Account Dimension (SCD Type 2)
==============================================================================*/

USE BankingERP;
GO

/*==============================================================
 Drop Existing Table
==============================================================*/
IF OBJECT_ID('Dim.DimAccount','U') IS NOT NULL
BEGIN
    DROP TABLE Dim.DimAccount;
END
GO

/*==============================================================
 Create Account Dimension
==============================================================*/
CREATE TABLE Dim.DimAccount
(
    ----------------------------------------------------------
    -- Surrogate Key
    ----------------------------------------------------------
    AccountKey BIGINT IDENTITY(1,1) NOT NULL,

    ----------------------------------------------------------
    -- Business Key
    ----------------------------------------------------------
    AccountID INT NOT NULL,
    AccountNumber VARCHAR(30) NOT NULL,

    ----------------------------------------------------------
    -- Relationships
    ----------------------------------------------------------
    CustomerID INT NOT NULL,
    BranchID INT NOT NULL,
    CurrencyCode CHAR(3) NOT NULL,

    ----------------------------------------------------------
    -- Account Details
    ----------------------------------------------------------
    AccountType VARCHAR(50),
    AccountCategory VARCHAR(50),
    AccountStatus VARCHAR(30),

    OpenDate DATE,
    CloseDate DATE NULL,

    InterestRate DECIMAL(8,4),
    MinimumBalance DECIMAL(18,2),

    ----------------------------------------------------------
    -- Audit Columns
    ----------------------------------------------------------
    SourceSystem VARCHAR(50),

    LoadDate DATETIME2
        CONSTRAINT DF_DimAccount_LoadDate
        DEFAULT SYSUTCDATETIME(),

    CreatedDate DATETIME2
        CONSTRAINT DF_DimAccount_CreatedDate
        DEFAULT SYSUTCDATETIME(),

    ModifiedDate DATETIME2 NULL,

    ----------------------------------------------------------
    -- SCD Type 2
    ----------------------------------------------------------
    EffectiveFrom DATETIME2 NOT NULL,

    EffectiveTo DATETIME2 NULL,

    IsCurrent BIT
        CONSTRAINT DF_DimAccount_IsCurrent
        DEFAULT(1),

    ----------------------------------------------------------
    -- CDC Hash
    ----------------------------------------------------------
    RowHash VARBINARY(32) NULL,

    ----------------------------------------------------------
    -- Constraints
    ----------------------------------------------------------
    CONSTRAINT PK_DimAccount
        PRIMARY KEY CLUSTERED(AccountKey),

    CONSTRAINT UQ_DimAccount
        UNIQUE(AccountID, EffectiveFrom)
);
GO

/*==============================================================
 Indexes
==============================================================*/

CREATE NONCLUSTERED INDEX IX_DimAccount_AccountID
ON Dim.DimAccount(AccountID);
GO

CREATE NONCLUSTERED INDEX IX_DimAccount_Customer
ON Dim.DimAccount(CustomerID);
GO

CREATE NONCLUSTERED INDEX IX_DimAccount_Branch
ON Dim.DimAccount(BranchID);
GO

CREATE NONCLUSTERED INDEX IX_DimAccount_Current
ON Dim.DimAccount(IsCurrent);
GO

/*==============================================================
 Validation
==============================================================*/

SELECT
TABLE_SCHEMA,
TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA='Dim'
AND TABLE_NAME='DimAccount';
GO

PRINT 'DimAccount Created Successfully';
GO
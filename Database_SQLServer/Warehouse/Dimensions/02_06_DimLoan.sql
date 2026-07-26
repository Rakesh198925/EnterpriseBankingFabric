/*==============================================================================
 Project      : Enterprise Banking Fabric
 Layer        : Enterprise Data Warehouse
 Script Name  : 02_06_DimLoan.sql
 Author       : Rakesh Soma
 Description  : Creates Loan Dimension (SCD Type 2)
==============================================================================*/

USE BankingERP;
GO

/*==============================================================
 Drop Existing Table
==============================================================*/
IF OBJECT_ID('Dim.DimLoan','U') IS NOT NULL
BEGIN
    DROP TABLE Dim.DimLoan;
END
GO

/*==============================================================
 Create Loan Dimension
==============================================================*/
CREATE TABLE Dim.DimLoan
(
    ----------------------------------------------------------
    -- Surrogate Key
    ----------------------------------------------------------
    LoanKey BIGINT IDENTITY(1,1) NOT NULL,

    ----------------------------------------------------------
    -- Business Key
    ----------------------------------------------------------
    LoanID INT NOT NULL,

    LoanNumber VARCHAR(30) NOT NULL,

    ----------------------------------------------------------
    -- Loan Details
    ----------------------------------------------------------
    LoanType VARCHAR(50),

    LoanProduct VARCHAR(100),

    LoanCategory VARCHAR(50),

    InterestRate DECIMAL(8,4),

    LoanTermMonths INT,

    RepaymentFrequency VARCHAR(30),

    CollateralType VARCHAR(100),

    RiskCategoryCode VARCHAR(20),

    LoanStatus VARCHAR(30),

    StartDate DATE,

    MaturityDate DATE,

    ----------------------------------------------------------
    -- Audit Columns
    ----------------------------------------------------------
    SourceSystem VARCHAR(50),

    LoadDate DATETIME2
        DEFAULT SYSUTCDATETIME(),

    CreatedDate DATETIME2
        DEFAULT SYSUTCDATETIME(),

    ModifiedDate DATETIME2 NULL,

    ----------------------------------------------------------
    -- SCD Type 2
    ----------------------------------------------------------
    EffectiveFrom DATETIME2 NOT NULL,

    EffectiveTo DATETIME2 NULL,

    IsCurrent BIT
        DEFAULT(1),

    ----------------------------------------------------------
    -- Row Hash
    ----------------------------------------------------------
    RowHash VARBINARY(32),

    ----------------------------------------------------------
    -- Constraints
    ----------------------------------------------------------
    CONSTRAINT PK_DimLoan
        PRIMARY KEY CLUSTERED (LoanKey),

    CONSTRAINT UQ_DimLoan
        UNIQUE (LoanID, EffectiveFrom)
);
GO

/*==============================================================
 Indexes
==============================================================*/

CREATE NONCLUSTERED INDEX IX_DimLoan_LoanID
ON Dim.DimLoan(LoanID);
GO

CREATE NONCLUSTERED INDEX IX_DimLoan_Status
ON Dim.DimLoan(LoanStatus);
GO

CREATE NONCLUSTERED INDEX IX_DimLoan_Risk
ON Dim.DimLoan(RiskCategoryCode);
GO

CREATE NONCLUSTERED INDEX IX_DimLoan_Current
ON Dim.DimLoan(IsCurrent);
GO

/*==============================================================
 Validation
==============================================================*/

SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA='Dim'
AND TABLE_NAME='DimLoan';
GO

PRINT 'DimLoan Created Successfully';
GO
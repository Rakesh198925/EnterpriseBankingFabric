/*==============================================================================
 Project      : Enterprise Banking Fabric
 Layer        : Enterprise Data Warehouse
 Script Name  : 02_04_DimCurrency.sql
 Author       : Rakesh Soma
 Description  : Creates Currency Dimension (SCD Type 1)
==============================================================================*/

USE BankingERP;
GO

/*==============================================================
 Drop Existing Table
==============================================================*/

IF OBJECT_ID('Dim.DimCurrency','U') IS NOT NULL
BEGIN
    DROP TABLE Dim.DimCurrency;
END
GO

/*==============================================================
 Create Currency Dimension
==============================================================*/

CREATE TABLE Dim.DimCurrency
(
    ----------------------------------------------------------
    -- Surrogate Key
    ----------------------------------------------------------
    CurrencyKey BIGINT IDENTITY(1,1) NOT NULL,

    ----------------------------------------------------------
    -- Business Key
    ----------------------------------------------------------
    CurrencyID INT NOT NULL,

    CurrencyCode CHAR(3) NOT NULL,

    ----------------------------------------------------------
    -- Currency Details
    ----------------------------------------------------------
    CurrencyName NVARCHAR(100) NOT NULL,

    CurrencySymbol NVARCHAR(10),

    DecimalPrecision TINYINT DEFAULT(2),

    IsBaseCurrency BIT DEFAULT(0),

    IsActive BIT DEFAULT(1),

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
    -- Constraints
    ----------------------------------------------------------
    CONSTRAINT PK_DimCurrency
        PRIMARY KEY CLUSTERED (CurrencyKey),

    CONSTRAINT UQ_DimCurrency
        UNIQUE (CurrencyCode)
);
GO

/*==============================================================
 Indexes
==============================================================*/

CREATE NONCLUSTERED INDEX IX_DimCurrency_Code
ON Dim.DimCurrency(CurrencyCode);
GO

CREATE NONCLUSTERED INDEX IX_DimCurrency_Active
ON Dim.DimCurrency(IsActive);
GO

/*==============================================================
 Validation
==============================================================*/

SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA='Dim'
AND TABLE_NAME='DimCurrency';
GO

PRINT 'DimCurrency Created Successfully';
GO
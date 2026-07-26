/*==============================================================================
 Project      : Enterprise Banking Fabric
 Layer        : Enterprise Data Warehouse
 Script Name  : 02_07_DimCard.sql
 Author       : Rakesh Soma
 Description  : Creates Card Dimension (SCD Type 2)
==============================================================================*/

USE BankingERP;
GO

/*==============================================================
 Drop Existing Table
==============================================================*/

IF OBJECT_ID('Dim.DimCard','U') IS NOT NULL
BEGIN
    DROP TABLE Dim.DimCard;
END
GO

/*==============================================================
 Create Card Dimension
==============================================================*/

CREATE TABLE Dim.DimCard
(
    ----------------------------------------------------------
    -- Surrogate Key
    ----------------------------------------------------------
    CardKey BIGINT IDENTITY(1,1) NOT NULL,

    ----------------------------------------------------------
    -- Business Key
    ----------------------------------------------------------
    CardID INT NOT NULL,

    CardNumber VARCHAR(30) NOT NULL,

    ----------------------------------------------------------
    -- Card Details
    ----------------------------------------------------------
    CardType VARCHAR(50),

    CardProduct VARCHAR(100),

    CardNetwork VARCHAR(30),

    CardCategory VARCHAR(50),

    CardStatus VARCHAR(30),

    CurrencyCode CHAR(3),

    IssueDate DATE,

    ExpiryDate DATE,

    DailyLimit DECIMAL(18,2),

    MonthlyLimit DECIMAL(18,2),

    ContactlessEnabled BIT,

    IsInternationalEnabled BIT,

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
    -- Change Tracking
    ----------------------------------------------------------
    RowHash VARBINARY(32),

    ----------------------------------------------------------
    -- Constraints
    ----------------------------------------------------------
    CONSTRAINT PK_DimCard
        PRIMARY KEY CLUSTERED(CardKey),

    CONSTRAINT UQ_DimCard
        UNIQUE(CardID, EffectiveFrom)
);
GO

/*==============================================================
 Indexes
==============================================================*/

CREATE NONCLUSTERED INDEX IX_DimCard_CardID
ON Dim.DimCard(CardID);
GO

CREATE NONCLUSTERED INDEX IX_DimCard_Status
ON Dim.DimCard(CardStatus);
GO

CREATE NONCLUSTERED INDEX IX_DimCard_Type
ON Dim.DimCard(CardType);
GO

CREATE NONCLUSTERED INDEX IX_DimCard_Current
ON Dim.DimCard(IsCurrent);
GO

/*==============================================================
 Validation
==============================================================*/

SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA='Dim'
AND TABLE_NAME='DimCard';
GO

PRINT 'DimCard Created Successfully';
GO
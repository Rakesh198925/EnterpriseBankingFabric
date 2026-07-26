/*==============================================================================
 Project      : Enterprise Banking Fabric
 Layer        : Enterprise Data Warehouse
 Script Name  : 02_08_DimRiskCategory.sql
 Author       : Rakesh Soma
 Description  : Creates Risk Category Dimension
==============================================================================*/

USE BankingERP;
GO

/*==============================================================
 Drop Existing Table
==============================================================*/

IF OBJECT_ID('Dim.DimRiskCategory','U') IS NOT NULL
BEGIN
    DROP TABLE Dim.DimRiskCategory;
END
GO

/*==============================================================
 Create Risk Category Dimension
==============================================================*/

CREATE TABLE Dim.DimRiskCategory
(
    ----------------------------------------------------------
    -- Surrogate Key
    ----------------------------------------------------------
    RiskCategoryKey BIGINT IDENTITY(1,1) NOT NULL,

    ----------------------------------------------------------
    -- Business Key
    ----------------------------------------------------------
    RiskCategoryID INT NOT NULL,

    RiskCategoryCode VARCHAR(20) NOT NULL,

    ----------------------------------------------------------
    -- Risk Details
    ----------------------------------------------------------
    RiskCategoryName NVARCHAR(100) NOT NULL,

    RiskLevel VARCHAR(20) NOT NULL,

    MinimumRiskScore DECIMAL(5,2),

    MaximumRiskScore DECIMAL(5,2),

    AMLRiskFlag BIT DEFAULT(0),

    KYCRiskFlag BIT DEFAULT(0),

    RegulatoryClassification NVARCHAR(100),

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
    CONSTRAINT PK_DimRiskCategory
        PRIMARY KEY CLUSTERED(RiskCategoryKey),

    CONSTRAINT UQ_DimRiskCategory
        UNIQUE(RiskCategoryCode)
);
GO

/*==============================================================
 Indexes
==============================================================*/

CREATE NONCLUSTERED INDEX IX_DimRiskCategory_Code
ON Dim.DimRiskCategory(RiskCategoryCode);
GO

CREATE NONCLUSTERED INDEX IX_DimRiskCategory_Level
ON Dim.DimRiskCategory(RiskLevel);
GO

CREATE NONCLUSTERED INDEX IX_DimRiskCategory_Active
ON Dim.DimRiskCategory(IsActive);
GO

/*==============================================================
 Validation
==============================================================*/

SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA='Dim'
AND TABLE_NAME='DimRiskCategory';
GO

PRINT 'DimRiskCategory Created Successfully';
GO
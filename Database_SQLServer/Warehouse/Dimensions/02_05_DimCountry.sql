/*==============================================================================
 Project      : Enterprise Banking Fabric
 Layer        : Enterprise Data Warehouse
 Script Name  : 02_05_DimCountry.sql
 Author       : Rakesh Soma
 Description  : Creates Country Dimension
==============================================================================*/

USE BankingERP;
GO

/*==============================================================
 Drop Existing Table
==============================================================*/
IF OBJECT_ID('Dim.DimCountry','U') IS NOT NULL
BEGIN
    DROP TABLE Dim.DimCountry;
END
GO

/*==============================================================
 Create Country Dimension
==============================================================*/
CREATE TABLE Dim.DimCountry
(
    ----------------------------------------------------------
    -- Surrogate Key
    ----------------------------------------------------------
    CountryKey BIGINT IDENTITY(1,1) NOT NULL,

    ----------------------------------------------------------
    -- Business Key
    ----------------------------------------------------------
    CountryID INT NOT NULL,

    CountryCode CHAR(2) NOT NULL,

    ----------------------------------------------------------
    -- Country Details
    ----------------------------------------------------------
    CountryName NVARCHAR(100) NOT NULL,

    ISO3Code CHAR(3),

    RegionName NVARCHAR(100),

    ContinentName NVARCHAR(100),

    CurrencyCode CHAR(3),

    TimeZoneName NVARCHAR(100),

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
    CONSTRAINT PK_DimCountry
        PRIMARY KEY CLUSTERED (CountryKey),

    CONSTRAINT UQ_DimCountry
        UNIQUE (CountryCode)
);
GO

/*==============================================================
 Indexes
==============================================================*/

CREATE NONCLUSTERED INDEX IX_DimCountry_Code
ON Dim.DimCountry(CountryCode);
GO

CREATE NONCLUSTERED INDEX IX_DimCountry_Name
ON Dim.DimCountry(CountryName);
GO

/*==============================================================
 Validation
==============================================================*/

SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA='Dim'
AND TABLE_NAME='DimCountry';
GO

PRINT 'DimCountry Created Successfully';
GO
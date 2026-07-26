/*==============================================================================
 Project      : Enterprise Banking Fabric
 Layer        : Enterprise Data Warehouse
 Script Name  : 02_01_DimCustomer.sql
 Author       : Rakesh Soma
 Description  : Creates Customer Dimension (SCD Type 2)
==============================================================================*/

USE BankingERP;
GO

IF OBJECT_ID('Dim.DimCustomer','U') IS NOT NULL
BEGIN
    DROP TABLE Dim.DimCustomer;
END
GO

CREATE TABLE Dim.DimCustomer
(
    ----------------------------------------------------------
    -- Surrogate Key
    ----------------------------------------------------------
    CustomerKey BIGINT IDENTITY(1,1) NOT NULL,

    ----------------------------------------------------------
    -- Business Key
    ----------------------------------------------------------
    CustomerID INT NOT NULL,

    CustomerNumber VARCHAR(30) NOT NULL,

    ----------------------------------------------------------
    -- Customer Information
    ----------------------------------------------------------
    FirstName NVARCHAR(100),

    MiddleName NVARCHAR(100),

    LastName NVARCHAR(100),

    FullName AS
        CONCAT(
            ISNULL(FirstName,''),
            ' ',
            ISNULL(LastName,'')
        ) PERSISTED,

    Gender CHAR(1),

    DateOfBirth DATE,

    NationalIdentificationNumber VARCHAR(30),

    CustomerTypeCode VARCHAR(20),

    OccupationCode VARCHAR(20),

    RiskCategoryCode VARCHAR(20),

    CountryCode CHAR(2),

    Nationality VARCHAR(100),

    EmailAddress NVARCHAR(200),

    MobileNumber VARCHAR(20),

    CustomerStatus VARCHAR(20),

    ----------------------------------------------------------
    -- Audit Columns
    ----------------------------------------------------------
    SourceSystem VARCHAR(50),

    LoadDate DATETIME2
        CONSTRAINT DF_DimCustomer_LoadDate
        DEFAULT SYSUTCDATETIME(),

    CreatedDate DATETIME2
        CONSTRAINT DF_DimCustomer_CreatedDate
        DEFAULT SYSUTCDATETIME(),

    ModifiedDate DATETIME2 NULL,

    ----------------------------------------------------------
    -- SCD Type 2
    ----------------------------------------------------------
    EffectiveFrom DATETIME2 NOT NULL,

    EffectiveTo DATETIME2 NULL,

    IsCurrent BIT
        CONSTRAINT DF_DimCustomer_IsCurrent
        DEFAULT(1),

    ----------------------------------------------------------
    -- Record Hash
    ----------------------------------------------------------
    RowHash VARBINARY(32) NULL,

    ----------------------------------------------------------
    -- Constraints
    ----------------------------------------------------------
    CONSTRAINT PK_DimCustomer
        PRIMARY KEY CLUSTERED(CustomerKey),

    CONSTRAINT UQ_DimCustomer
        UNIQUE(CustomerID,EffectiveFrom)
);
GO
/*==============================================================================
 Project      : Enterprise Banking Fabric
 Layer        : Enterprise Data Warehouse
 Script Name  : 02_02_DimBranch.sql
 Author       : Rakesh Soma
 Description  : Creates Branch Dimension (SCD Type 2)
==============================================================================*/


USE BankingERP;
GO


/*==============================================================
 Drop Existing Table
==============================================================*/

IF OBJECT_ID('Dim.DimBranch','U') IS NOT NULL
BEGIN
    DROP TABLE Dim.DimBranch;
END
GO



/*==============================================================
 Create Dimension Table
==============================================================*/

CREATE TABLE Dim.DimBranch
(

    ----------------------------------------------------------
    -- Surrogate Key
    ----------------------------------------------------------

    BranchKey BIGINT IDENTITY(1,1)
        NOT NULL,


    ----------------------------------------------------------
    -- Business Key
    ----------------------------------------------------------

    BranchID INT NOT NULL,

    BranchCode VARCHAR(20) NOT NULL,


    ----------------------------------------------------------
    -- Branch Attributes
    ----------------------------------------------------------

    BranchName NVARCHAR(200) NOT NULL,

    BranchType VARCHAR(50),

    BranchCategory VARCHAR(50),


    ----------------------------------------------------------
    -- Location Details
    ----------------------------------------------------------

    AddressLine1 NVARCHAR(200),

    AddressLine2 NVARCHAR(200),

    City NVARCHAR(100),

    State NVARCHAR(100),

    PostalCode VARCHAR(20),

    CountryCode CHAR(2),


    ----------------------------------------------------------
    -- Contact Information
    ----------------------------------------------------------

    PhoneNumber VARCHAR(20),

    EmailAddress NVARCHAR(200),


    ----------------------------------------------------------
    -- Operational Information
    ----------------------------------------------------------

    OpeningDate DATE,

    ClosingDate DATE NULL,

    BranchStatus VARCHAR(20),


    ----------------------------------------------------------
    -- Audit Information
    ----------------------------------------------------------

    SourceSystem VARCHAR(50),


    LoadDate DATETIME2
        CONSTRAINT DF_DimBranch_LoadDate
        DEFAULT SYSUTCDATETIME(),


    CreatedDate DATETIME2
        CONSTRAINT DF_DimBranch_CreatedDate
        DEFAULT SYSUTCDATETIME(),


    ModifiedDate DATETIME2 NULL,


    ----------------------------------------------------------
    -- SCD Type 2 Columns
    ----------------------------------------------------------

    EffectiveFrom DATETIME2 NOT NULL,


    EffectiveTo DATETIME2 NULL,


    IsCurrent BIT
        CONSTRAINT DF_DimBranch_IsCurrent
        DEFAULT(1),


    ----------------------------------------------------------
    -- Change Detection
    ----------------------------------------------------------

    RowHash VARBINARY(32) NULL,



    ----------------------------------------------------------
    -- Constraints
    ----------------------------------------------------------

    CONSTRAINT PK_DimBranch
        PRIMARY KEY CLUSTERED
        (
            BranchKey
        ),


    CONSTRAINT UQ_DimBranch_BusinessKey
        UNIQUE
        (
            BranchID,
            EffectiveFrom
        )

);
GO



/*==============================================================
 Indexes
==============================================================*/


CREATE NONCLUSTERED INDEX IX_DimBranch_BranchID
ON Dim.DimBranch
(
    BranchID
);
GO



CREATE NONCLUSTERED INDEX IX_DimBranch_BranchCode
ON Dim.DimBranch
(
    BranchCode
);
GO



CREATE NONCLUSTERED INDEX IX_DimBranch_Current
ON Dim.DimBranch
(
    IsCurrent
);
GO



CREATE NONCLUSTERED INDEX IX_DimBranch_Country
ON Dim.DimBranch
(
    CountryCode
);
GO



/*==============================================================
 Validation
==============================================================*/

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA='Dim'
AND TABLE_NAME='DimBranch';
GO


PRINT 'DimBranch Created Successfully';
GO
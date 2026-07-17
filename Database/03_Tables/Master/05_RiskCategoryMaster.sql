/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Master Data
Schema       : Master
Table        : RiskCategoryMaster
Author       : Rakesh Soma
Version      : 2.0
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Master.RiskCategoryMaster','U') IS NOT NULL
BEGIN
    DROP TABLE Master.RiskCategoryMaster;
END;
GO

CREATE TABLE Master.RiskCategoryMaster
(
    -------------------------------------------------------------------------
    -- Primary Key
    -------------------------------------------------------------------------
    RiskCategoryID INT IDENTITY(1,1)
        CONSTRAINT PK_RiskCategoryMaster
        PRIMARY KEY CLUSTERED,

    -------------------------------------------------------------------------
    -- Business Columns
    -------------------------------------------------------------------------
    RiskCategoryCode VARCHAR(20) NOT NULL,

    RiskCategoryName VARCHAR(100) NOT NULL,

    RiskScore TINYINT NOT NULL,

    Description VARCHAR(250) NULL,

    -------------------------------------------------------------------------
    -- Audit Columns
    -------------------------------------------------------------------------
    IsActive BIT NOT NULL
        CONSTRAINT DF_RiskCategoryMaster_IsActive DEFAULT (1),

    CreatedDate DATETIME2(7) NOT NULL
        CONSTRAINT DF_RiskCategoryMaster_CreatedDate DEFAULT (SYSDATETIME()),

    CreatedBy SYSNAME NOT NULL
        CONSTRAINT DF_RiskCategoryMaster_CreatedBy DEFAULT (SUSER_SNAME()),

    ModifiedDate DATETIME2(7) NULL,

    ModifiedBy SYSNAME NULL,

    -------------------------------------------------------------------------
    -- Constraints
    -------------------------------------------------------------------------
    CONSTRAINT UQ_RiskCategoryMaster_Code
        UNIQUE(RiskCategoryCode),

    CONSTRAINT UQ_RiskCategoryMaster_Name
        UNIQUE(RiskCategoryName),

    CONSTRAINT CK_RiskCategoryMaster_RiskScore
        CHECK(RiskScore BETWEEN 1 AND 100),

    CONSTRAINT CK_RiskCategoryMaster_Name
        CHECK(LEN(LTRIM(RTRIM(RiskCategoryName))) > 0)
);
GO

/******************************************************************************
Indexes
******************************************************************************/

CREATE NONCLUSTERED INDEX IX_RiskCategoryMaster_Code
ON Master.RiskCategoryMaster(RiskCategoryCode);
GO

CREATE NONCLUSTERED INDEX IX_RiskCategoryMaster_Name
ON Master.RiskCategoryMaster(RiskCategoryName);
GO

CREATE NONCLUSTERED INDEX IX_RiskCategoryMaster_RiskScore
ON Master.RiskCategoryMaster(RiskScore);
GO

CREATE NONCLUSTERED INDEX IX_RiskCategoryMaster_IsActive
ON Master.RiskCategoryMaster(IsActive);
GO

/******************************************************************************
Extended Property
******************************************************************************/

EXEC sys.sp_addextendedproperty
    @name='MS_Description',
    @value='Stores customer risk categories used for KYC and credit assessment.',
    @level0type='SCHEMA',@level0name='Master',
    @level1type='TABLE',@level1name='RiskCategoryMaster';
GO


------Insert Data ----------------

INSERT INTO Master.RiskCategoryMaster
(
    RiskCategoryCode,
    RiskCategoryName,
    RiskScore,
    Description
)
VALUES
('LOW','Low Risk',20,'Minimal financial risk'),
('MED','Medium Risk',50,'Moderate financial risk'),
('HIGH','High Risk',80,'High financial risk'),
('VHIGH','Very High Risk',95,'Very high financial risk'),
('CRITICAL','Critical Risk',100,'Critical monitoring required');
GO

-----------Validation----
------EXEC sp_help 'Master.RiskCategoryMaster';
GO

EXEC sp_helpindex 'Master.RiskCategoryMaster';
GO

EXEC sp_helpconstraint 'Master.RiskCategoryMaster';
GO

SELECT *
FROM Master.RiskCategoryMaster
ORDER BY RiskScore;
GO
/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Master Data
Schema       : Master
Table        : CurrencyMaster
Author       : Rakesh Soma
Version      : 2.0
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Master.CurrencyMaster','U') IS NOT NULL
BEGIN
    DROP TABLE Master.CurrencyMaster;
END;
GO

CREATE TABLE Master.CurrencyMaster
(
    --------------------------------------------------------------------------
    -- Primary Key
    --------------------------------------------------------------------------
    CurrencyID INT IDENTITY(1,1)
        CONSTRAINT PK_CurrencyMaster
        PRIMARY KEY CLUSTERED,

    --------------------------------------------------------------------------
    -- Business Columns
    --------------------------------------------------------------------------
    CurrencyCode CHAR(3) NOT NULL,

    CurrencyName VARCHAR(100) NOT NULL,

    CurrencySymbol VARCHAR(10) NOT NULL,

    DecimalPrecision TINYINT NOT NULL
        CONSTRAINT DF_CurrencyMaster_DecimalPrecision DEFAULT (2),

    IsBaseCurrency BIT NOT NULL
        CONSTRAINT DF_CurrencyMaster_IsBaseCurrency DEFAULT (0),

    --------------------------------------------------------------------------
    -- Audit Columns
    --------------------------------------------------------------------------
    IsActive BIT NOT NULL
        CONSTRAINT DF_CurrencyMaster_IsActive DEFAULT (1),

    CreatedDate DATETIME2(7) NOT NULL
        CONSTRAINT DF_CurrencyMaster_CreatedDate DEFAULT (SYSDATETIME()),

    CreatedBy SYSNAME NOT NULL
        CONSTRAINT DF_CurrencyMaster_CreatedBy DEFAULT (SUSER_SNAME()),

    ModifiedDate DATETIME2(7) NULL,

    ModifiedBy SYSNAME NULL,

    --------------------------------------------------------------------------
    -- Constraints
    --------------------------------------------------------------------------
    CONSTRAINT UQ_CurrencyMaster_CurrencyCode
        UNIQUE (CurrencyCode),

    CONSTRAINT UQ_CurrencyMaster_CurrencyName
        UNIQUE (CurrencyName),

    CONSTRAINT CK_CurrencyMaster_Code
        CHECK (LEN(CurrencyCode)=3),

    CONSTRAINT CK_CurrencyMaster_Name
        CHECK (LEN(LTRIM(RTRIM(CurrencyName)))>0),

    CONSTRAINT CK_CurrencyMaster_DecimalPrecision
        CHECK (DecimalPrecision BETWEEN 0 AND 6)
);
GO

/******************************************************************************
Indexes
******************************************************************************/

CREATE NONCLUSTERED INDEX IX_CurrencyMaster_CurrencyCode
ON Master.CurrencyMaster(CurrencyCode);
GO

CREATE NONCLUSTERED INDEX IX_CurrencyMaster_CurrencyName
ON Master.CurrencyMaster(CurrencyName);
GO

CREATE NONCLUSTERED INDEX IX_CurrencyMaster_IsActive
ON Master.CurrencyMaster(IsActive);
GO

/******************************************************************************
Extended Property
******************************************************************************/

EXEC sys.sp_addextendedproperty
    @name='MS_Description',
    @value='Stores currency master details.',
    @level0type='SCHEMA',@level0name='Master',
    @level1type='TABLE',@level1name='CurrencyMaster';
GO



------inser data-----------

INSERT INTO Master.CurrencyMaster
(
    CurrencyCode,
    CurrencyName,
    CurrencySymbol,
    DecimalPrecision,
    IsBaseCurrency
)
VALUES
('INR','Indian Rupee','₹',2,0),
('EUR','Euro','€',2,1),
('USD','US Dollar','$',2,0),
('GBP','British Pound','£',2,0),
('CHF','Swiss Franc','CHF',2,0);
GO
-------Validation-----

EXEC sp_help 'Master.CurrencyMaster';
GO

EXEC sp_helpindex 'Master.CurrencyMaster';
GO

EXEC sp_helpconstraint 'Master.CurrencyMaster';
GO

SELECT *
FROM Master.CurrencyMaster
ORDER BY CurrencyName;
GO
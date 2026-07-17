/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Master Data
Schema       : Master
Table        : CardTypeMaster
Author       : Rakesh Soma
Version      : 2.0
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Master.CardTypeMaster','U') IS NOT NULL
    DROP TABLE Master.CardTypeMaster;
GO

CREATE TABLE Master.CardTypeMaster
(
    -------------------------------------------------------------------------
    -- Primary Key
    -------------------------------------------------------------------------
    CardTypeID INT IDENTITY(1,1)
        CONSTRAINT PK_CardTypeMaster
        PRIMARY KEY CLUSTERED,

    -------------------------------------------------------------------------
    -- Business Columns
    -------------------------------------------------------------------------
    CardTypeCode VARCHAR(20) NOT NULL,

    CardTypeName VARCHAR(100) NOT NULL,

    CardCategory VARCHAR(20) NOT NULL,

    AnnualFee DECIMAL(10,2) NOT NULL,

    CreditLimit DECIMAL(18,2) NULL,

    ContactlessEnabled BIT NOT NULL
        CONSTRAINT DF_CardTypeMaster_Contactless DEFAULT(1),

    Description VARCHAR(250) NULL,

    -------------------------------------------------------------------------
    -- Audit Columns
    -------------------------------------------------------------------------
    IsActive BIT NOT NULL
        CONSTRAINT DF_CardTypeMaster_IsActive DEFAULT(1),

    CreatedDate DATETIME2(7) NOT NULL
        CONSTRAINT DF_CardTypeMaster_CreatedDate DEFAULT(SYSDATETIME()),

    CreatedBy SYSNAME NOT NULL
        CONSTRAINT DF_CardTypeMaster_CreatedBy DEFAULT(SUSER_SNAME()),

    ModifiedDate DATETIME2(7) NULL,

    ModifiedBy SYSNAME NULL,

    -------------------------------------------------------------------------
    -- Constraints
    -------------------------------------------------------------------------
    CONSTRAINT UQ_CardTypeMaster_Code UNIQUE(CardTypeCode),

    CONSTRAINT UQ_CardTypeMaster_Name UNIQUE(CardTypeName),

    CONSTRAINT CK_CardTypeMaster_Category
        CHECK(CardCategory IN
        (
            'Debit',
            'Credit',
            'Prepaid'
        )),

    CONSTRAINT CK_CardTypeMaster_AnnualFee
        CHECK(AnnualFee>=0),

    CONSTRAINT CK_CardTypeMaster_CreditLimit
        CHECK(CreditLimit IS NULL OR CreditLimit>=0)
);
GO

/******************************************************************************
Indexes
******************************************************************************/

CREATE INDEX IX_CardTypeMaster_Code
ON Master.CardTypeMaster(CardTypeCode);
GO

CREATE INDEX IX_CardTypeMaster_Category
ON Master.CardTypeMaster(CardCategory);
GO

CREATE INDEX IX_CardTypeMaster_IsActive
ON Master.CardTypeMaster(IsActive);
GO

/******************************************************************************
Extended Property
******************************************************************************/

EXEC sys.sp_addextendedproperty
@name='MS_Description',
@value='Stores banking card type master information.',
@level0type='SCHEMA',@level0name='Master',
@level1type='TABLE',@level1name='CardTypeMaster';
GO

--------Insert Data --------

INSERT INTO Master.CardTypeMaster
(
CardTypeCode,
CardTypeName,
CardCategory,
AnnualFee,
CreditLimit,
ContactlessEnabled,
Description
)
VALUES
('DBSTD','Debit Standard','Debit',0,NULL,1,'Standard Debit Card'),

('DBPREM','Debit Premium','Debit',500,NULL,1,'Premium Debit Card'),

('CRCLASS','Credit Classic','Credit',1000,100000,1,'Classic Credit Card'),

('CRPLAT','Credit Platinum','Credit',3000,500000,1,'Platinum Credit Card'),

('PREPAID','Prepaid Card','Prepaid',200,NULL,1,'Reloadable Prepaid Card');
GO

------Validation------


EXEC sp_help 'Master.CardTypeMaster';
GO

EXEC sp_helpindex 'Master.CardTypeMaster';
GO

EXEC sp_helpconstraint 'Master.CardTypeMaster';
GO

SELECT *
FROM Master.CardTypeMaster
ORDER BY CardTypeName;
GO
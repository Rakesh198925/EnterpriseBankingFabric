/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Master Data
Schema       : Master
Table        : AccountTypeMaster
Author       : Rakesh Soma
Version      : 2.0
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Master.AccountTypeMaster','U') IS NOT NULL
BEGIN
    DROP TABLE Master.AccountTypeMaster;
END;
GO

CREATE TABLE Master.AccountTypeMaster
(
    -------------------------------------------------------------------------
    -- Primary Key
    -------------------------------------------------------------------------
    AccountTypeID INT IDENTITY(1,1)
        CONSTRAINT PK_AccountTypeMaster
        PRIMARY KEY CLUSTERED,

    -------------------------------------------------------------------------
    -- Business Columns
    -------------------------------------------------------------------------
    AccountTypeCode VARCHAR(20) NOT NULL,

    AccountTypeName VARCHAR(100) NOT NULL,

    AccountCategory VARCHAR(30) NOT NULL,

    MinimumBalance DECIMAL(18,2) NOT NULL,

    InterestRate DECIMAL(5,2) NOT NULL,

    OverdraftAllowed BIT NOT NULL,

    Description VARCHAR(250) NULL,

    -------------------------------------------------------------------------
    -- Audit Columns
    -------------------------------------------------------------------------
    IsActive BIT NOT NULL
        CONSTRAINT DF_AccountTypeMaster_IsActive DEFAULT(1),

    CreatedDate DATETIME2(7) NOT NULL
        CONSTRAINT DF_AccountTypeMaster_CreatedDate DEFAULT(SYSDATETIME()),

    CreatedBy SYSNAME NOT NULL
        CONSTRAINT DF_AccountTypeMaster_CreatedBy DEFAULT(SUSER_SNAME()),

    ModifiedDate DATETIME2(7) NULL,

    ModifiedBy SYSNAME NULL,

    -------------------------------------------------------------------------
    -- Constraints
    -------------------------------------------------------------------------
    CONSTRAINT UQ_AccountTypeMaster_Code
        UNIQUE(AccountTypeCode),

    CONSTRAINT UQ_AccountTypeMaster_Name
        UNIQUE(AccountTypeName),

    CONSTRAINT CK_AccountTypeMaster_Category
        CHECK(AccountCategory IN
        (
            'Savings',
            'Current',
            'Fixed Deposit',
            'Loan'
        )),

    CONSTRAINT CK_AccountTypeMaster_MinBalance
        CHECK(MinimumBalance>=0),

    CONSTRAINT CK_AccountTypeMaster_Interest
        CHECK(InterestRate>=0 AND InterestRate<=20)
);
GO

/******************************************************************************
Indexes
******************************************************************************/

CREATE NONCLUSTERED INDEX IX_AccountTypeMaster_Code
ON Master.AccountTypeMaster(AccountTypeCode);
GO

CREATE NONCLUSTERED INDEX IX_AccountTypeMaster_Name
ON Master.AccountTypeMaster(AccountTypeName);
GO

CREATE NONCLUSTERED INDEX IX_AccountTypeMaster_Category
ON Master.AccountTypeMaster(AccountCategory);
GO

/******************************************************************************
Extended Property
******************************************************************************/

EXEC sys.sp_addextendedproperty
@name='MS_Description',
@value='Stores account type master information.',
@level0type='SCHEMA',@level0name='Master',
@level1type='TABLE',@level1name='AccountTypeMaster';
GO


------Insert Data------

INSERT INTO Master.AccountTypeMaster
(
AccountTypeCode,
AccountTypeName,
AccountCategory,
MinimumBalance,
InterestRate,
OverdraftAllowed,
Description
)
VALUES
('SB','Savings Account','Savings',1000,3.50,0,'Regular Savings'),
('CA','Current Account','Current',5000,0.00,1,'Business Current'),
('FD','Fixed Deposit','Fixed Deposit',10000,6.75,0,'Fixed Deposit'),
('SAL','Salary Account','Savings',0,2.75,0,'Salary Credit'),
('NRI','NRI Savings','Savings',5000,3.75,0,'NRI Account');
GO


-------Validation-----

EXEC sp_help 'Master.AccountTypeMaster';
GO

EXEC sp_helpindex 'Master.AccountTypeMaster';
GO

EXEC sp_helpconstraint 'Master.AccountTypeMaster';
GO

SELECT *
FROM Master.AccountTypeMaster
ORDER BY AccountTypeName;
GO
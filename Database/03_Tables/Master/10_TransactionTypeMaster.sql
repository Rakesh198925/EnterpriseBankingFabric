/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Master Data
Schema       : Master
Table        : TransactionTypeMaster
Author       : Rakesh Soma
Version      : 2.0
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Master.TransactionTypeMaster','U') IS NOT NULL
    DROP TABLE Master.TransactionTypeMaster;
GO

CREATE TABLE Master.TransactionTypeMaster
(
    -------------------------------------------------------------------------
    -- Primary Key
    -------------------------------------------------------------------------
    TransactionTypeID INT IDENTITY(1,1)
        CONSTRAINT PK_TransactionTypeMaster
        PRIMARY KEY CLUSTERED,

    -------------------------------------------------------------------------
    -- Business Columns
    -------------------------------------------------------------------------
    TransactionTypeCode VARCHAR(20) NOT NULL,

    TransactionTypeName VARCHAR(100) NOT NULL,

    DebitCreditFlag CHAR(1) NOT NULL,

    Description VARCHAR(250) NULL,

    -------------------------------------------------------------------------
    -- Audit Columns
    -------------------------------------------------------------------------
    IsActive BIT NOT NULL
        CONSTRAINT DF_TransactionTypeMaster_IsActive DEFAULT(1),

    CreatedDate DATETIME2(7) NOT NULL
        CONSTRAINT DF_TransactionTypeMaster_CreatedDate DEFAULT(SYSDATETIME()),

    CreatedBy SYSNAME NOT NULL
        CONSTRAINT DF_TransactionTypeMaster_CreatedBy DEFAULT(SUSER_SNAME()),

    ModifiedDate DATETIME2(7) NULL,

    ModifiedBy SYSNAME NULL,

    -------------------------------------------------------------------------
    -- Constraints
    -------------------------------------------------------------------------
    CONSTRAINT UQ_TransactionTypeMaster_Code
        UNIQUE(TransactionTypeCode),

    CONSTRAINT UQ_TransactionTypeMaster_Name
        UNIQUE(TransactionTypeName),

    CONSTRAINT CK_TransactionTypeMaster_DebitCredit
        CHECK (DebitCreditFlag IN ('D','C')),

    CONSTRAINT CK_TransactionTypeMaster_Name
        CHECK(LEN(LTRIM(RTRIM(TransactionTypeName))) > 0)
);
GO

/******************************************************************************
Indexes
******************************************************************************/

CREATE NONCLUSTERED INDEX IX_TransactionTypeMaster_Code
ON Master.TransactionTypeMaster(TransactionTypeCode);
GO

CREATE NONCLUSTERED INDEX IX_TransactionTypeMaster_Name
ON Master.TransactionTypeMaster(TransactionTypeName);
GO

CREATE NONCLUSTERED INDEX IX_TransactionTypeMaster_Flag
ON Master.TransactionTypeMaster(DebitCreditFlag);
GO

CREATE NONCLUSTERED INDEX IX_TransactionTypeMaster_IsActive
ON Master.TransactionTypeMaster(IsActive);
GO

/******************************************************************************
Extended Property
******************************************************************************/

EXEC sys.sp_addextendedproperty
@name='MS_Description',
@value='Stores banking transaction types.',
@level0type='SCHEMA',@level0name='Master',
@level1type='TABLE',@level1name='TransactionTypeMaster';
GO


-----------Insert Data ------------

INSERT INTO Master.TransactionTypeMaster
(
TransactionTypeCode,
TransactionTypeName,
DebitCreditFlag,
Description
)
VALUES
('DEP','Cash Deposit','C','Cash deposited into account'),

('WDL','Cash Withdrawal','D','Cash withdrawn from account'),

('FTIN','Fund Transfer In','C','Incoming fund transfer'),

('FTOUT','Fund Transfer Out','D','Outgoing fund transfer'),

('ATM','ATM Withdrawal','D','Cash withdrawal using ATM'),

('POS','POS Purchase','D','Card purchase at merchant'),

('SAL','Salary Credit','C','Salary credited'),

('INT','Interest Credit','C','Interest credited'),

('CHG','Bank Charges','D','Service charges'),

('REV','Transaction Reversal','C','Reversal of previous transaction');
GO


------Validation----

EXEC sp_help 'Master.TransactionTypeMaster';
GO

EXEC sp_helpindex 'Master.TransactionTypeMaster';
GO

EXEC sp_helpconstraint 'Master.TransactionTypeMaster';
GO

SELECT *
FROM Master.TransactionTypeMaster
ORDER BY TransactionTypeName;
GO
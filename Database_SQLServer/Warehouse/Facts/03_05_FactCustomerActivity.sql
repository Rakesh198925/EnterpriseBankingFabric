/*==============================================================================
 Project      : Enterprise Banking Fabric
 Layer        : Enterprise Data Warehouse
 Script Name  : 03_05_FactCustomerActivity.sql
 Author       : Rakesh Soma
 Description  : Creates Enterprise Customer Activity Fact Table
==============================================================================*/

USE BankingERP;
GO

/*==============================================================
 Drop Existing Table
==============================================================*/

IF OBJECT_ID('Fact.FactCustomerActivity','U') IS NOT NULL
BEGIN
    DROP TABLE Fact.FactCustomerActivity;
END
GO

/*==============================================================
 Create FactCustomerActivity
==============================================================*/

CREATE TABLE Fact.FactCustomerActivity
(
    ----------------------------------------------------------
    -- Fact Key
    ----------------------------------------------------------
    CustomerActivityKey BIGINT IDENTITY(1,1) NOT NULL,

    ----------------------------------------------------------
    -- Business Key
    ----------------------------------------------------------
    ActivityID BIGINT NOT NULL,

    ----------------------------------------------------------
    -- Dimension Keys
    ----------------------------------------------------------
    CustomerKey BIGINT NOT NULL,

    AccountKey BIGINT NULL,

    BranchKey BIGINT NOT NULL,

    DateKey INT NOT NULL,

    TimeKey INT NOT NULL,

    ----------------------------------------------------------
    -- Activity Details
    ----------------------------------------------------------
    ActivityType VARCHAR(100),

    ActivityChannel VARCHAR(50),

    DeviceType VARCHAR(50),

    LoginMethod VARCHAR(50),

    SessionID VARCHAR(100),

    ActivityStatus VARCHAR(30),

    ----------------------------------------------------------
    -- Customer Metrics
    ----------------------------------------------------------
    SessionDurationSeconds INT DEFAULT(0),

    LoginCount INT DEFAULT(1),

    TransactionCount INT DEFAULT(0),

    PageViews INT DEFAULT(0),

    ----------------------------------------------------------
    -- Flags
    ----------------------------------------------------------
    IsMobile BIT DEFAULT(0),

    IsInternetBanking BIT DEFAULT(0),

    IsATM BIT DEFAULT(0),

    IsBranchVisit BIT DEFAULT(0),

    IsCallCenter BIT DEFAULT(0),

    ----------------------------------------------------------
    -- Audit Columns
    ----------------------------------------------------------
    SourceSystem VARCHAR(50),

    ETLBatchID UNIQUEIDENTIFIER,

    LoadDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    ----------------------------------------------------------
    -- Constraints
    ----------------------------------------------------------
    CONSTRAINT PK_FactCustomerActivity
        PRIMARY KEY CLUSTERED(CustomerActivityKey),

    CONSTRAINT FK_FCA_Customer
        FOREIGN KEY(CustomerKey)
        REFERENCES Dim.DimCustomer(CustomerKey),

    CONSTRAINT FK_FCA_Account
        FOREIGN KEY(AccountKey)
        REFERENCES Dim.DimAccount(AccountKey),

    CONSTRAINT FK_FCA_Branch
        FOREIGN KEY(BranchKey)
        REFERENCES Dim.DimBranch(BranchKey),

    CONSTRAINT FK_FCA_Date
        FOREIGN KEY(DateKey)
        REFERENCES Dim.DimDate(DateKey),

    CONSTRAINT FK_FCA_Time
        FOREIGN KEY(TimeKey)
        REFERENCES Dim.DimTime(TimeKey)
);
GO

/*==============================================================
 Indexes
==============================================================*/

CREATE NONCLUSTERED INDEX IX_FCA_DateKey
ON Fact.FactCustomerActivity(DateKey);
GO

CREATE NONCLUSTERED INDEX IX_FCA_CustomerKey
ON Fact.FactCustomerActivity(CustomerKey);
GO

CREATE NONCLUSTERED INDEX IX_FCA_ActivityType
ON Fact.FactCustomerActivity(ActivityType);
GO

CREATE NONCLUSTERED INDEX IX_FCA_Channel
ON Fact.FactCustomerActivity(ActivityChannel);
GO

CREATE NONCLUSTERED INDEX IX_FCA_Status
ON Fact.FactCustomerActivity(ActivityStatus);
GO

/*==============================================================
 Validation
==============================================================*/

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA='Fact'
AND TABLE_NAME='FactCustomerActivity';
GO

PRINT 'FactCustomerActivity Created Successfully';
GO
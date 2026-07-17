/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Master Data
Schema       : Master
Table        : BranchMaster
Author       : Rakesh Soma
Version      : 2.0
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Master.BranchMaster','U') IS NOT NULL
BEGIN
    DROP TABLE Master.BranchMaster;
END;
GO

CREATE TABLE Master.BranchMaster
(
    -------------------------------------------------------------------------
    -- Primary Key
    -------------------------------------------------------------------------
    BranchID INT IDENTITY(1,1)
        CONSTRAINT PK_BranchMaster
        PRIMARY KEY CLUSTERED,

    -------------------------------------------------------------------------
    -- Business Columns
    -------------------------------------------------------------------------
    BranchCode VARCHAR(20) NOT NULL,

    BranchName VARCHAR(150) NOT NULL,

    CountryID INT NOT NULL,

    City VARCHAR(100) NOT NULL,

    BranchAddress VARCHAR(300) NULL,

    PostalCode VARCHAR(20) NULL,

    PhoneNumber VARCHAR(20) NULL,

    EmailAddress VARCHAR(100) NULL,

    -------------------------------------------------------------------------
    -- Audit Columns
    -------------------------------------------------------------------------
    IsActive BIT NOT NULL
        CONSTRAINT DF_BranchMaster_IsActive DEFAULT (1),

    CreatedDate DATETIME2(7) NOT NULL
        CONSTRAINT DF_BranchMaster_CreatedDate DEFAULT (SYSDATETIME()),

    CreatedBy SYSNAME NOT NULL
        CONSTRAINT DF_BranchMaster_CreatedBy DEFAULT (SUSER_SNAME()),

    ModifiedDate DATETIME2(7) NULL,

    ModifiedBy SYSNAME NULL,

    -------------------------------------------------------------------------
    -- Constraints
    -------------------------------------------------------------------------
    CONSTRAINT UQ_BranchMaster_BranchCode
        UNIQUE (BranchCode),

    CONSTRAINT CK_BranchMaster_BranchName
        CHECK (LEN(LTRIM(RTRIM(BranchName))) > 0),

    CONSTRAINT CK_BranchMaster_Email
        CHECK (EmailAddress IS NULL OR EmailAddress LIKE '%@%.%'),

    CONSTRAINT FK_BranchMaster_Country
        FOREIGN KEY (CountryID)
        REFERENCES Master.CountryMaster(CountryID)
);
GO

/******************************************************************************
Indexes
******************************************************************************/

CREATE NONCLUSTERED INDEX IX_BranchMaster_CountryID
ON Master.BranchMaster(CountryID);
GO

CREATE NONCLUSTERED INDEX IX_BranchMaster_BranchCode
ON Master.BranchMaster(BranchCode);
GO

CREATE NONCLUSTERED INDEX IX_BranchMaster_City
ON Master.BranchMaster(City);
GO

CREATE NONCLUSTERED INDEX IX_BranchMaster_IsActive
ON Master.BranchMaster(IsActive);
GO

/******************************************************************************
Extended Property
******************************************************************************/

EXEC sys.sp_addextendedproperty
    @name='MS_Description',
    @value='Stores banking branch master information.',
    @level0type='SCHEMA',@level0name='Master',
    @level1type='TABLE',@level1name='BranchMaster';
GO

------Insert Data-----------

INSERT INTO Master.BranchMaster
(
    BranchCode,
    BranchName,
    CountryID,
    City,
    BranchAddress,
    PostalCode,
    PhoneNumber,
    EmailAddress
)
VALUES
('IND001','Bangalore Main Branch',1,'Bangalore','MG Road','560001','08012345678','blr@bank.com'),

('LUX001','Luxembourg Central',2,'Luxembourg City','Grand Rue','L-1000','35226123456','lux@bank.com'),

('USA001','New York Branch',3,'New York','5th Avenue','10001','12125551234','ny@bank.com'),

('CAN001','Toronto Branch',4,'Toronto','Bay Street','M5H2N2','14165551234','toronto@bank.com'),

('DEU001','Berlin Branch',5,'Berlin','Alexanderplatz','10178','49301234567','berlin@bank.com');
GO


--------Validation-----

EXEC sp_help 'Master.BranchMaster';
GO

EXEC sp_helpindex 'Master.BranchMaster';
GO

EXEC sp_helpconstraint 'Master.BranchMaster';
GO

SELECT *
FROM Master.BranchMaster
ORDER BY BranchName;
GO
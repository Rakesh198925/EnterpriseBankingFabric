/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Master Data
Schema       : Master
Table        : CustomerTypeMaster
Author       : Rakesh Soma
Version      : 2.0
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Master.CustomerTypeMaster','U') IS NOT NULL
BEGIN
    DROP TABLE Master.CustomerTypeMaster;
END;
GO

CREATE TABLE Master.CustomerTypeMaster
(
    -------------------------------------------------------------------------
    -- Primary Key
    -------------------------------------------------------------------------
    CustomerTypeID INT IDENTITY(1,1)
        CONSTRAINT PK_CustomerTypeMaster
        PRIMARY KEY CLUSTERED,

    -------------------------------------------------------------------------
    -- Business Columns
    -------------------------------------------------------------------------
    CustomerTypeCode VARCHAR(20) NOT NULL,

    CustomerTypeName VARCHAR(100) NOT NULL,

    Description VARCHAR(250) NULL,

    -------------------------------------------------------------------------
    -- Audit Columns
    -------------------------------------------------------------------------
    IsActive BIT NOT NULL
        CONSTRAINT DF_CustomerTypeMaster_IsActive DEFAULT (1),

    CreatedDate DATETIME2(7) NOT NULL
        CONSTRAINT DF_CustomerTypeMaster_CreatedDate DEFAULT (SYSDATETIME()),

    CreatedBy SYSNAME NOT NULL
        CONSTRAINT DF_CustomerTypeMaster_CreatedBy DEFAULT (SUSER_SNAME()),

    ModifiedDate DATETIME2(7) NULL,

    ModifiedBy SYSNAME NULL,

    -------------------------------------------------------------------------
    -- Constraints
    -------------------------------------------------------------------------
    CONSTRAINT UQ_CustomerTypeMaster_Code
        UNIQUE(CustomerTypeCode),

    CONSTRAINT UQ_CustomerTypeMaster_Name
        UNIQUE(CustomerTypeName),

    CONSTRAINT CK_CustomerTypeMaster_Name
        CHECK(LEN(LTRIM(RTRIM(CustomerTypeName))) > 0)
);
GO

/******************************************************************************
Indexes
******************************************************************************/

CREATE NONCLUSTERED INDEX IX_CustomerTypeMaster_Code
ON Master.CustomerTypeMaster(CustomerTypeCode);
GO

CREATE NONCLUSTERED INDEX IX_CustomerTypeMaster_Name
ON Master.CustomerTypeMaster(CustomerTypeName);
GO

CREATE NONCLUSTERED INDEX IX_CustomerTypeMaster_IsActive
ON Master.CustomerTypeMaster(IsActive);
GO

/******************************************************************************
Extended Property
******************************************************************************/

EXEC sys.sp_addextendedproperty
@name='MS_Description',
@value='Stores customer type master information.',
@level0type='SCHEMA',@level0name='Master',
@level1type='TABLE',@level1name='CustomerTypeMaster';
GO


-----Insert Data------

INSERT INTO Master.CustomerTypeMaster
(
    CustomerTypeCode,
    CustomerTypeName,
    Description
)
VALUES
('IND','Individual','Retail Individual Customer'),
('CORP','Corporate','Corporate Business Customer'),
('SME','SME','Small and Medium Enterprise'),
('NRI','NRI','Non Resident Indian'),
('GOV','Government','Government Organization');
GO


------Validation------

EXEC sp_help 'Master.CustomerTypeMaster';
GO

EXEC sp_helpindex 'Master.CustomerTypeMaster';
GO

EXEC sp_helpconstraint 'Master.CustomerTypeMaster';
GO

SELECT *
FROM Master.CustomerTypeMaster
ORDER BY CustomerTypeName;
GO
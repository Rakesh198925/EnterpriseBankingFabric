/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Master Data
Schema       : Master
Table        : OccupationMaster
Author       : Rakesh Soma
Version      : 2.0
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Master.OccupationMaster','U') IS NOT NULL
BEGIN
    DROP TABLE Master.OccupationMaster;
END;
GO

CREATE TABLE Master.OccupationMaster
(
    -------------------------------------------------------------------------
    -- Primary Key
    -------------------------------------------------------------------------
    OccupationID INT IDENTITY(1,1)
        CONSTRAINT PK_OccupationMaster
        PRIMARY KEY CLUSTERED,

    -------------------------------------------------------------------------
    -- Business Columns
    -------------------------------------------------------------------------
    OccupationCode VARCHAR(20) NOT NULL,

    OccupationName VARCHAR(100) NOT NULL,

    OccupationCategory VARCHAR(50) NOT NULL,

    Description VARCHAR(250) NULL,

    -------------------------------------------------------------------------
    -- Audit Columns
    -------------------------------------------------------------------------
    IsActive BIT NOT NULL
        CONSTRAINT DF_OccupationMaster_IsActive DEFAULT (1),

    CreatedDate DATETIME2(7) NOT NULL
        CONSTRAINT DF_OccupationMaster_CreatedDate DEFAULT (SYSDATETIME()),

    CreatedBy SYSNAME NOT NULL
        CONSTRAINT DF_OccupationMaster_CreatedBy DEFAULT (SUSER_SNAME()),

    ModifiedDate DATETIME2(7) NULL,

    ModifiedBy SYSNAME NULL,

    -------------------------------------------------------------------------
    -- Constraints
    -------------------------------------------------------------------------
    CONSTRAINT UQ_OccupationMaster_Code
        UNIQUE (OccupationCode),

    CONSTRAINT UQ_OccupationMaster_Name
        UNIQUE (OccupationName),

    CONSTRAINT CK_OccupationMaster_Name
        CHECK (LEN(LTRIM(RTRIM(OccupationName))) > 0),

    CONSTRAINT CK_OccupationMaster_Category
        CHECK (OccupationCategory IN
        (
            'Salaried',
            'Business',
            'Professional',
            'Government',
            'Student',
            'Retired',
            'Other'
        ))
);
GO

/******************************************************************************
Indexes
******************************************************************************/

CREATE NONCLUSTERED INDEX IX_OccupationMaster_Code
ON Master.OccupationMaster(OccupationCode);
GO

CREATE NONCLUSTERED INDEX IX_OccupationMaster_Name
ON Master.OccupationMaster(OccupationName);
GO

CREATE NONCLUSTERED INDEX IX_OccupationMaster_Category
ON Master.OccupationMaster(OccupationCategory);
GO

CREATE NONCLUSTERED INDEX IX_OccupationMaster_IsActive
ON Master.OccupationMaster(IsActive);
GO

/******************************************************************************
Extended Property
******************************************************************************/

EXEC sys.sp_addextendedproperty
    @name='MS_Description',
    @value='Stores customer occupation master information.',
    @level0type='SCHEMA', @level0name='Master',
    @level1type='TABLE', @level1name='OccupationMaster';
GO


------Insret data-------
INSERT INTO Master.OccupationMaster
(
    OccupationCode,
    OccupationName,
    OccupationCategory,
    Description
)
VALUES
('SE','Software Engineer','Professional','Software Development'),
('DOC','Doctor','Professional','Medical Practitioner'),
('BUS','Business Owner','Business','Own Business'),
('GOV','Government Employee','Government','Government Sector'),
('STU','Student','Student','College or School Student'),
('RET','Retired','Retired','Retired Employee'),
('SAL','Private Employee','Salaried','Private Sector Employee');
GO



--------Validation-----------


EXEC sp_help 'Master.OccupationMaster';
GO

EXEC sp_helpindex 'Master.OccupationMaster';
GO

EXEC sp_helpconstraint 'Master.OccupationMaster';
GO

SELECT *
FROM Master.OccupationMaster
ORDER BY OccupationName;
GO
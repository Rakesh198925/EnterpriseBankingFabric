USE BankingERP;
GO

IF OBJECT_ID('Master.CountryMaster', 'U') IS NOT NULL
    DROP TABLE Master.CountryMaster;
GO

CREATE TABLE Master.CountryMaster
(
    CountryID INT IDENTITY(1,1) CONSTRAINT PK_CountryMaster PRIMARY KEY,

    CountryCode CHAR(3) NOT NULL,

    CountryName VARCHAR(100) NOT NULL,

    ISOCode CHAR(2) NOT NULL,

    Region VARCHAR(100) NULL,

    IsActive BIT NOT NULL
        CONSTRAINT DF_Country_IsActive DEFAULT(1),

    CreatedDate DATETIME2 NOT NULL
        CONSTRAINT DF_Country_CreatedDate DEFAULT(SYSDATETIME()),

    CreatedBy SYSNAME NOT NULL
        CONSTRAINT DF_Country_CreatedBy DEFAULT(SUSER_SNAME()),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy SYSNAME NULL,

    CONSTRAINT UQ_CountryMaster_CountryCode UNIQUE(CountryCode),

    CONSTRAINT UQ_CountryMaster_ISOCode UNIQUE(ISOCode)
);
GO
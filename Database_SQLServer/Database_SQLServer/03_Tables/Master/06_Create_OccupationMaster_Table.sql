USE BankingERP;
GO

IF OBJECT_ID('Master.OccupationMaster','U') IS NULL
BEGIN

CREATE TABLE Master.OccupationMaster
(
    OccupationID INT IDENTITY(1,1)
        CONSTRAINT PK_OccupationMaster PRIMARY KEY,

    OccupationCode VARCHAR(20) NOT NULL UNIQUE,

    OccupationName NVARCHAR(100) NOT NULL,

    Industry NVARCHAR(100),

    Description NVARCHAR(250),

    IsActive BIT NOT NULL DEFAULT 1,

    CreatedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SUSER_SNAME(),

    ModifiedDate DATETIME2,

    ModifiedBy NVARCHAR(100)
);

END
GO
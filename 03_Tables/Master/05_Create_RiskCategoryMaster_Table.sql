USE BankingERP;
GO

IF OBJECT_ID('Master.RiskCategoryMaster','U') IS NULL
BEGIN

CREATE TABLE Master.RiskCategoryMaster
(
    RiskCategoryID INT IDENTITY(1,1)
        CONSTRAINT PK_RiskCategoryMaster PRIMARY KEY,

    RiskCode VARCHAR(20) NOT NULL UNIQUE,

    RiskName NVARCHAR(100) NOT NULL,

    RiskScore INT,

    Description NVARCHAR(250),

    IsActive BIT NOT NULL DEFAULT 1,

    CreatedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SUSER_SNAME(),

    ModifiedDate DATETIME2,

    ModifiedBy NVARCHAR(100)
);

END
GO
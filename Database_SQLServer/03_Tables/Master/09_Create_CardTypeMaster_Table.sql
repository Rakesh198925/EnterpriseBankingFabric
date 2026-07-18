USE BankingERP;
GO

IF OBJECT_ID('Master.CardTypeMaster','U') IS NULL
BEGIN

CREATE TABLE Master.CardTypeMaster
(
    CardTypeID INT IDENTITY(1,1)
        CONSTRAINT PK_CardTypeMaster PRIMARY KEY,

    CardTypeCode VARCHAR(20) NOT NULL UNIQUE,

    CardTypeName NVARCHAR(100) NOT NULL,

    CardNetwork NVARCHAR(50),

    CreditLimit DECIMAL(18,2),

    AnnualFee DECIMAL(18,2),

    Description NVARCHAR(250),

    IsActive BIT NOT NULL DEFAULT 1,

    CreatedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SUSER_SNAME(),

    ModifiedDate DATETIME2,

    ModifiedBy NVARCHAR(100)
);

END
GO
USE BankingERP;
GO

IF OBJECT_ID('Master.LoanTypeMaster','U') IS NULL
BEGIN

CREATE TABLE Master.LoanTypeMaster
(
    LoanTypeID INT IDENTITY(1,1)
        CONSTRAINT PK_LoanTypeMaster PRIMARY KEY,

    LoanTypeCode VARCHAR(20) NOT NULL UNIQUE,

    LoanTypeName NVARCHAR(100) NOT NULL,

    DefaultInterestRate DECIMAL(5,2),

    MaximumTenureMonths INT,

    Description NVARCHAR(250),

    IsActive BIT NOT NULL DEFAULT 1,

    CreatedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SUSER_SNAME(),

    ModifiedDate DATETIME2,

    ModifiedBy NVARCHAR(100)
);

END
GO
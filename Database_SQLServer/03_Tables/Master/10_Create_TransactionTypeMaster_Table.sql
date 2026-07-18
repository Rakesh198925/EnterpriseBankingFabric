USE BankingERP;
GO

IF OBJECT_ID('Master.TransactionTypeMaster','U') IS NULL
BEGIN

CREATE TABLE Master.TransactionTypeMaster
(
    TransactionTypeID INT IDENTITY(1,1)
        CONSTRAINT PK_TransactionTypeMaster PRIMARY KEY,

    TransactionTypeCode VARCHAR(20) NOT NULL UNIQUE,

    TransactionTypeName NVARCHAR(100) NOT NULL,

    TransactionCategory NVARCHAR(50),

    IsDebit BIT,

    Description NVARCHAR(250),

    IsActive BIT NOT NULL DEFAULT 1,

    CreatedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SUSER_SNAME(),

    ModifiedDate DATETIME2,

    ModifiedBy NVARCHAR(100)
);

END
GO
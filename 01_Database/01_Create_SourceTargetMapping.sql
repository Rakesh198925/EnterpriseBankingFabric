USE BankingERP;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'Config'
)
BEGIN
    EXEC('CREATE SCHEMA Config');
END
GO

/******************************************************************************
Project : Enterprise Banking Fabric
Module  : Configuration
Script  : 01_Create_SourceTargetMapping.sql
Author  : Rakesh Soma
Purpose : Metadata driven source target configuration
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Config.SourceTargetMapping','U') IS NOT NULL
    DROP TABLE Config.SourceTargetMapping;
GO

CREATE TABLE Config.SourceTargetMapping
(
    MappingID INT IDENTITY(1,1) PRIMARY KEY,

    SourceSchema VARCHAR(50) NOT NULL,
    SourceTable VARCHAR(100) NOT NULL,

    DestinationLayer VARCHAR(20) NOT NULL,
    DestinationTable VARCHAR(100) NOT NULL,

    LoadType VARCHAR(20) NOT NULL,

    IsActive BIT NOT NULL DEFAULT 1,

    LoadSequence INT NOT NULL,

    CreatedDate DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME()
);
GO

----------------Load Master Metadata------------

INSERT INTO Config.SourceTargetMapping
(
SourceSchema,
SourceTable,
DestinationLayer,
DestinationTable,
LoadType,
LoadSequence
)

VALUES

('Master','CountryMaster','Bronze','CountryMaster','Full',1),

('Master','CurrencyMaster','Bronze','CurrencyMaster','Full',2),

('Master','BranchMaster','Bronze','BranchMaster','Full',3),

('Master','CustomerTypeMaster','Bronze','CustomerTypeMaster','Full',4),

('Master','AccountTypeMaster','Bronze','AccountTypeMaster','Full',5),

('Master','LoanTypeMaster','Bronze','LoanTypeMaster','Full',6),

('Master','CardTypeMaster','Bronze','CardTypeMaster','Full',7),

('Master','RiskCategoryMaster','Bronze','RiskCategoryMaster','Full',8),

('Master','OccupationMaster','Bronze','OccupationMaster','Full',9),

('Master','TransactionTypeMaster','Bronze','TransactionTypeMaster','Full',10);
GO


----------Verify-------------
SELECT *
FROM Config.SourceTargetMapping
ORDER BY LoadSequence;



-----add new column-----

ALTER TABLE Config.SourceTargetMapping
ADD DestinationSchema VARCHAR(50);
GO

UPDATE Config.SourceTargetMapping
SET DestinationSchema = 'dbo';
GO



SELECT
    SourceSchema,
    SourceTable,
    DestinationSchema,
    DestinationTable,
    LoadType,
    LoadSequence
FROM Config.SourceTargetMapping
WHERE IsActive = 1
ORDER BY LoadSequence;

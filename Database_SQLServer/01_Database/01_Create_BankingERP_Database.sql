/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Database Setup
Script     : 01_Create_BankingERP_Database.sql
Author     : Rakesh Soma
Purpose    : Create BankingERP source database for SQL Server to Microsoft Fabric migration
******************************************************************************/

USE master;
GO


PRINT '=============================================';
PRINT 'CREATING BANKINGERP DATABASE';
PRINT '=============================================';
GO


IF DB_ID('BankingERP') IS NOT NULL
BEGIN
    PRINT 'BankingERP database already exists';
END
ELSE
BEGIN

    CREATE DATABASE BankingERP;

    PRINT 'BankingERP database created successfully';

END
GO


USE BankingERP;
GO


PRINT '=============================================';
PRINT 'CONFIGURING DATABASE SETTINGS';
PRINT '=============================================';
GO


ALTER DATABASE BankingERP
SET RECOVERY SIMPLE;
GO


ALTER DATABASE BankingERP
SET AUTO_CLOSE OFF;
GO


ALTER DATABASE BankingERP
SET AUTO_SHRINK OFF;
GO


ALTER DATABASE BankingERP
SET READ_COMMITTED_SNAPSHOT ON;
GO



PRINT '=============================================';
PRINT 'CREATING DATABASE METADATA';
PRINT '=============================================';
GO


IF OBJECT_ID('dbo.DatabaseVersion','U') IS NULL
BEGIN

CREATE TABLE dbo.DatabaseVersion
(
    DatabaseVersionID INT IDENTITY(1,1)
        CONSTRAINT PK_DatabaseVersion PRIMARY KEY,

    VersionNumber VARCHAR(20) NOT NULL,

    Description VARCHAR(500) NULL,

    DeploymentDate DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    DeployedBy VARCHAR(100) NOT NULL
        DEFAULT SUSER_SNAME()
);

END
GO



INSERT INTO dbo.DatabaseVersion
(
    VersionNumber,
    Description
)
VALUES
(
    '1.0',
    'Initial BankingERP database creation for Fabric migration project'
);
GO



PRINT '=============================================';
PRINT 'BANKINGERP DATABASE SETUP COMPLETED';
PRINT '=============================================';
GO
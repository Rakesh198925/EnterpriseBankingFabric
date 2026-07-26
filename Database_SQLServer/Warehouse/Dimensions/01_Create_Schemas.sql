/*==============================================================================
 Project      : Enterprise Banking Fabric
 Layer        : Enterprise Data Warehouse
 Script Name  : 01_Create_Schemas.sql
 Author       : Rakesh Soma
 Description  : Creates enterprise warehouse supporting schemas
 Version      : 1.0
==============================================================================*/

USE BankingERP;
GO

PRINT '============================================================';
PRINT 'Enterprise Banking Warehouse - Create Schemas';
PRINT '============================================================';
GO

/*==============================================================
 Create Schema : Config
==============================================================*/
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Config')
BEGIN
    EXEC ('CREATE SCHEMA Config');
    PRINT 'Schema [Config] created.';
END
ELSE
BEGIN
    PRINT 'Schema [Config] already exists.';
END
GO

/*==============================================================
 Create Schema : Stage
==============================================================*/
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Stage')
BEGIN
    EXEC ('CREATE SCHEMA Stage');
    PRINT 'Schema [Stage] created.';
END
ELSE
BEGIN
    PRINT 'Schema [Stage] already exists.';
END
GO

/*==============================================================
 Create Schema : Dim
==============================================================*/
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Dim')
BEGIN
    EXEC ('CREATE SCHEMA Dim');
    PRINT 'Schema [Dim] created.';
END
ELSE
BEGIN
    PRINT 'Schema [Dim] already exists.';
END
GO

/*==============================================================
 Create Schema : Fact
==============================================================*/
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Fact')
BEGIN
    EXEC ('CREATE SCHEMA Fact');
    PRINT 'Schema [Fact] created.';
END
ELSE
BEGIN
    PRINT 'Schema [Fact] already exists.';
END
GO

/*==============================================================
 Create Schema : Reporting
==============================================================*/
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Reporting')
BEGIN
    EXEC ('CREATE SCHEMA Reporting');
    PRINT 'Schema [Reporting] created.';
END
ELSE
BEGIN
    PRINT 'Schema [Reporting] already exists.';
END
GO

/*==============================================================
 Create Schema : Audit
==============================================================*/
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Audit')
BEGIN
    EXEC ('CREATE SCHEMA Audit');
    PRINT 'Schema [Audit] created.';
END
ELSE
BEGIN
    PRINT 'Schema [Audit] already exists.';
END
GO

/*==============================================================
 Create Schema : Security
==============================================================*/
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Security')
BEGIN
    EXEC ('CREATE SCHEMA Security');
    PRINT 'Schema [Security] created.';
END
ELSE
BEGIN
    PRINT 'Schema [Security] already exists.';
END
GO

/*==============================================================
 Verification
==============================================================*/

PRINT '';
PRINT 'Schemas Available';
PRINT '-----------------';

SELECT
    name AS SchemaName
FROM sys.schemas
WHERE name IN
(
'Config',
'Stage',
'Dim',
'Fact',
'Reporting',
'Audit',
'Security'
)
ORDER BY name;
GO

PRINT '============================================================';
PRINT 'Enterprise Warehouse Schemas Created Successfully';
PRINT '============================================================';
GO
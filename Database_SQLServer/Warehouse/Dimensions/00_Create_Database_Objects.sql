/*==============================================================================
 Project      : Enterprise Banking Fabric
 Layer        : Enterprise Data Warehouse
 Script Name  : 00_Create_Database_Objects.sql
 Author       : Rakesh Soma
 Description  : Creates all required schemas for the Enterprise Data Warehouse
==============================================================================*/

PRINT '====================================================';
PRINT 'Creating Enterprise Data Warehouse Schemas';
PRINT '====================================================';

--=========================================================
-- Create Schema : Dim
--=========================================================
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

--=========================================================
-- Create Schema : Fact
--=========================================================
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

--=========================================================
-- Create Schema : Reporting
--=========================================================
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

--=========================================================
-- Create Schema : Audit
--=========================================================
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

--=========================================================
-- Create Schema : Stage
--=========================================================
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

PRINT '====================================================';
PRINT 'Enterprise Warehouse Schemas Created Successfully';
PRINT '====================================================';
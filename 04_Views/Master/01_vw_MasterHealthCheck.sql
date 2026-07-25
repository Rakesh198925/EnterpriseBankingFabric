/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Master Data Quality
View       : Master.vw_MasterHealthCheck
Author     : Rakesh Soma

Purpose:
    Enterprise master data validation before Fabric migration
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER VIEW Master.vw_MasterHealthCheck
AS

SELECT
    'CountryMaster' AS TableName,
    COUNT(*) AS TotalRecords,
    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END) AS ActiveRecords,
    SUM(CASE WHEN IsActive = 0 THEN 1 ELSE 0 END) AS InactiveRecords
FROM Master.CountryMaster


UNION ALL


SELECT
    'CurrencyMaster',
    COUNT(*),
    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END),
    SUM(CASE WHEN IsActive = 0 THEN 1 ELSE 0 END)
FROM Master.CurrencyMaster


UNION ALL


SELECT
    'BranchMaster',
    COUNT(*),
    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END),
    SUM(CASE WHEN IsActive = 0 THEN 1 ELSE 0 END)
FROM Master.BranchMaster


UNION ALL


SELECT
    'CustomerTypeMaster',
    COUNT(*),
    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END),
    SUM(CASE WHEN IsActive = 0 THEN 1 ELSE 0 END)
FROM Master.CustomerTypeMaster


UNION ALL


SELECT
    'RiskCategoryMaster',
    COUNT(*),
    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END),
    SUM(CASE WHEN IsActive = 0 THEN 1 ELSE 0 END)
FROM Master.RiskCategoryMaster


UNION ALL


SELECT
    'OccupationMaster',
    COUNT(*),
    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END),
    SUM(CASE WHEN IsActive = 0 THEN 1 ELSE 0 END)
FROM Master.OccupationMaster


UNION ALL


SELECT
    'AccountTypeMaster',
    COUNT(*),
    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END),
    SUM(CASE WHEN IsActive = 0 THEN 1 ELSE 0 END)
FROM Master.AccountTypeMaster


UNION ALL


SELECT
    'LoanTypeMaster',
    COUNT(*),
    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END),
    SUM(CASE WHEN IsActive = 0 THEN 1 ELSE 0 END)
FROM Master.LoanTypeMaster


UNION ALL


SELECT
    'CardTypeMaster',
    COUNT(*),
    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END),
    SUM(CASE WHEN IsActive = 0 THEN 1 ELSE 0 END)
FROM Master.CardTypeMaster


UNION ALL


SELECT
    'TransactionTypeMaster',
    COUNT(*),
    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END),
    SUM(CASE WHEN IsActive = 0 THEN 1 ELSE 0 END)
FROM Master.TransactionTypeMaster;

GO
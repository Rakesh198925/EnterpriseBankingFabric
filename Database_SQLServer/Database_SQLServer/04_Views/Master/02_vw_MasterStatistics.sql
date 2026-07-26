/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Master Analytics
View       : Master.vw_MasterStatistics
Author     : Rakesh Soma
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER VIEW Master.vw_MasterStatistics
AS

SELECT
    'Country' AS MasterEntity,
    COUNT(*) AS TotalCount
FROM Master.CountryMaster


UNION ALL


SELECT
    'Currency',
    COUNT(*)
FROM Master.CurrencyMaster


UNION ALL


SELECT
    'Branch',
    COUNT(*)
FROM Master.BranchMaster


UNION ALL


SELECT
    'Customer Type',
    COUNT(*)
FROM Master.CustomerTypeMaster


UNION ALL


SELECT
    'Risk Category',
    COUNT(*)
FROM Master.RiskCategoryMaster


UNION ALL


SELECT
    'Occupation',
    COUNT(*)
FROM Master.OccupationMaster


UNION ALL


SELECT
    'Account Type',
    COUNT(*)
FROM Master.AccountTypeMaster


UNION ALL


SELECT
    'Loan Type',
    COUNT(*)
FROM Master.LoanTypeMaster


UNION ALL


SELECT
    'Card Type',
    COUNT(*)
FROM Master.CardTypeMaster


UNION ALL


SELECT
    'Transaction Type',
    COUNT(*)
FROM Master.TransactionTypeMaster;

GO
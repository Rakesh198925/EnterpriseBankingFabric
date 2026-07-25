/******************************************************************************
Project  : Enterprise Banking Data Platform
Script   : 07_Master_Validation.sql
Author   : Rakesh Soma
Purpose  : Validate Master Data
******************************************************************************/

USE BankingERP;
GO

PRINT 'MASTER TABLE RECORD COUNTS';

SELECT 'CountryMaster' AS TableName, COUNT(*) AS TotalRows FROM Master.CountryMaster
UNION ALL
SELECT 'CurrencyMaster', COUNT(*) FROM Master.CurrencyMaster
UNION ALL
SELECT 'CustomerTypeMaster', COUNT(*) FROM Master.CustomerTypeMaster
UNION ALL
SELECT 'RiskCategoryMaster', COUNT(*) FROM Master.RiskCategoryMaster
UNION ALL
SELECT 'OccupationMaster', COUNT(*) FROM Master.OccupationMaster
UNION ALL
SELECT 'AccountTypeMaster', COUNT(*) FROM Master.AccountTypeMaster
UNION ALL
SELECT 'LoanTypeMaster', COUNT(*) FROM Master.LoanTypeMaster
UNION ALL
SELECT 'CardTypeMaster', COUNT(*) FROM Master.CardTypeMaster
UNION ALL
SELECT 'TransactionTypeMaster', COUNT(*) FROM Master.TransactionTypeMaster
UNION ALL
SELECT 'BranchMaster', COUNT(*) FROM Master.BranchMaster;
GO
/******************************************************************************
Project  : Enterprise Banking Data Platform
Script   : 03_Create_Master_Tables.sql
Author   : Rakesh Soma
Purpose  : Master Table Deployment Order
******************************************************************************/

USE BankingERP;
GO

PRINT '=============================================';
PRINT 'MASTER TABLE DEPLOYMENT STARTED';
PRINT '=============================================';
GO

PRINT 'Execute the following scripts in order:';

PRINT '01_CountryMaster.sql';
PRINT '02_CurrencyMaster.sql';
PRINT '03_BranchMaster.sql';
PRINT '04_CustomerTypeMaster.sql';
PRINT '05_RiskCategoryMaster.sql';
PRINT '06_OccupationMaster.sql';
PRINT '07_AccountTypeMaster.sql';
PRINT '08_LoanTypeMaster.sql';
PRINT '09_CardTypeMaster.sql';
PRINT '10_TransactionTypeMaster.sql';
GO

PRINT '=============================================';
PRINT 'MASTER TABLE DEPLOYMENT COMPLETED';
PRINT '=============================================';
GO
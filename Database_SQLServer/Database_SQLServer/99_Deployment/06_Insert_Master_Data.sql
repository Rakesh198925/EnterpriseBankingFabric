USE BankingERP;
GO

PRINT '=============================================';
PRINT 'MASTER DATA LOAD STARTED';
PRINT '=============================================';

EXEC Master.usp_LoadCountryMaster;
EXEC Master.usp_LoadCurrencyMaster;
EXEC Master.usp_LoadCustomerTypeMaster;
EXEC Master.usp_LoadRiskCategoryMaster;
EXEC Master.usp_LoadOccupationMaster;
EXEC Master.usp_LoadAccountTypeMaster;
EXEC Master.usp_LoadLoanTypeMaster;
EXEC Master.usp_LoadCardTypeMaster;
EXEC Master.usp_LoadTransactionTypeMaster;
EXEC Master.usp_LoadBranchMaster;

PRINT '=============================================';
PRINT 'MASTER DATA LOAD COMPLETED';
PRINT '=============================================';
GO
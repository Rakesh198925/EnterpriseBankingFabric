/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Master Data Deployment
Procedure  : Master.usp_LoadAllMasterData
Author     : Rakesh Soma

Purpose:
    Load all Enterprise Banking Master Data

Execution Order:
    1. Country
    2. Currency
    3. Branch
    4. Customer Type
    5. Risk Category
    6. Occupation
    7. Account Type
    8. Loan Type
    9. Card Type
    10. Transaction Type

******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER PROCEDURE Master.usp_LoadAllMasterData
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


BEGIN TRY


BEGIN TRANSACTION;


PRINT '================================================';
PRINT 'Enterprise Banking Master Data Load Started';
PRINT '================================================';



--------------------------------------------------
-- 01 Country
--------------------------------------------------

EXEC Master.usp_LoadCountryMaster;



--------------------------------------------------
-- 02 Currency
--------------------------------------------------

EXEC Master.usp_LoadCurrencyMaster;



--------------------------------------------------
-- 03 Branch
--------------------------------------------------

EXEC Master.usp_LoadBranchMaster;



--------------------------------------------------
-- 04 Customer Type
--------------------------------------------------

EXEC Master.usp_LoadCustomerTypeMaster;



--------------------------------------------------
-- 05 Risk Category
--------------------------------------------------

EXEC Master.usp_LoadRiskCategoryMaster;



--------------------------------------------------
-- 06 Occupation
--------------------------------------------------

EXEC Master.usp_LoadOccupationMaster;



--------------------------------------------------
-- 07 Account Type
--------------------------------------------------

EXEC Master.usp_LoadAccountTypeMaster;



--------------------------------------------------
-- 08 Loan Type
--------------------------------------------------

EXEC Master.usp_LoadLoanTypeMaster;



--------------------------------------------------
-- 09 Card Type
--------------------------------------------------

EXEC Master.usp_LoadCardTypeMaster;



--------------------------------------------------
-- 10 Transaction Type
--------------------------------------------------

EXEC Master.usp_LoadTransactionTypeMaster;



COMMIT TRANSACTION;



PRINT '================================================';
PRINT 'Enterprise Banking Master Data Load Completed';
PRINT '================================================';


SELECT
    'All Master Data Loaded Successfully'
    AS Message;



END TRY


BEGIN CATCH


IF @@TRANCOUNT > 0
    ROLLBACK TRANSACTION;


DECLARE 
    @ErrorMessage NVARCHAR(4000);


SET @ErrorMessage = ERROR_MESSAGE();


THROW 50001,
@ErrorMessage,
1;


END CATCH


END;
GO
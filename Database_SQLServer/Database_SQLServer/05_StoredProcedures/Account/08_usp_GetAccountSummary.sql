/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Account
Procedure  : usp_GetAccountSummary
Author     : Rakesh Soma
Purpose    : Retrieve account summary for reporting and customer view
Technology : SQL Server 2019
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Account.usp_GetAccountSummary
(
      @AccountID INT
)
AS
BEGIN

SET NOCOUNT ON;


BEGIN TRY


    ---------------------------------------------------------
    -- Account Summary
    ---------------------------------------------------------

    SELECT

        A.AccountID,
        A.AccountNumber,
        A.IBAN,
        A.AccountName,

        A.CustomerID,

        C.FirstName + ' ' + C.LastName AS CustomerName,

        A.AccountStatus,

        A.OpenDate,
        A.CloseDate,

        A.AvailableBalance,
        A.CurrentBalance,

        A.OverdraftLimit,

        A.IsJointAccount,

        B.BranchID,

        AT.AccountTypeID,

        A.CurrencyID,


        -----------------------------------------------------
        -- Holder Count
        -----------------------------------------------------

        (
            SELECT COUNT(*)
            FROM Account.AccountHolder AH
            WHERE AH.AccountID = A.AccountID
              AND AH.IsActive = 1
        ) AS TotalAccountHolders,


        -----------------------------------------------------
        -- Latest Balance Date
        -----------------------------------------------------

        (
            SELECT MAX(BalanceDate)
            FROM Account.AccountBalance AB
            WHERE AB.AccountID = A.AccountID
        ) AS LastBalanceDate,


        -----------------------------------------------------
        -- Transaction Limit
        -----------------------------------------------------

        ATL.DailyATMWithdrawalLimit,
        ATL.DailyPOSLimit,
        ATL.DailyOnlineTransferLimit,
        ATL.DailyCashDepositLimit,
        ATL.CurrencyCode


    FROM Account.Account A


    INNER JOIN Customer.Customer C
        ON A.CustomerID = C.CustomerID


    INNER JOIN Account.AccountType AT
        ON A.AccountTypeID = AT.AccountTypeID


    LEFT JOIN Account.AccountTransactionLimit ATL
        ON A.AccountID = ATL.AccountID
       AND ATL.EffectiveTo IS NULL


    LEFT JOIN Master.BranchMaster B
        ON A.BranchID = B.BranchID


    WHERE A.AccountID = @AccountID;



END TRY

BEGIN CATCH

    THROW;

END CATCH

END;
GO
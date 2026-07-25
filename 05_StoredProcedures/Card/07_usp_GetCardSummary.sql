/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Card
Procedure  : usp_GetCardSummary
Author     : Rakesh Soma
Purpose    : Customer card summary for reporting and Power BI
Technology : SQL Server 2019
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER PROCEDURE Card.usp_GetCardSummary
(
      @CardID INT
)
AS
BEGIN

SET NOCOUNT ON;


BEGIN TRY


SELECT

    C.CardID,

    C.CardNumber,

    C.CardHolderName,

    C.CustomerID,

    CU.FirstName + ' ' + CU.LastName AS CustomerName,


    C.AccountID,

    C.CardTypeID,

    C.CardBrand,


    C.IssueDate,

    C.ExpiryDate,

    C.CardStatus,


    C.ContactlessEnabled,

    C.InternationalUsageEnabled,

    C.OnlineUsageEnabled,

    C.ATMUsageEnabled,



    ---------------------------------------------------------
    -- Card Limits
    ---------------------------------------------------------

    CL.DailyATMWithdrawalLimit,

    CL.DailyPOSLimit,

    CL.DailyOnlineLimit,

    CL.ContactlessLimit,



    ---------------------------------------------------------
    -- Transaction Statistics
    ---------------------------------------------------------

    (
        SELECT COUNT(*)
        FROM Card.CardTransaction CT
        WHERE CT.CardID = C.CardID
    ) AS TotalTransactions,


    (
        SELECT ISNULL(SUM(TransactionAmount),0)
        FROM Card.CardTransaction CT
        WHERE CT.CardID = C.CardID
          AND TransactionStatus = 'SUCCESS'
    ) AS TotalTransactionAmount,


    (
        SELECT COUNT(*)
        FROM Card.CardAuthorization CA
        WHERE CA.CardID = C.CardID
          AND AuthorizationStatus = 'APPROVED'
    ) AS ApprovedAuthorizations



FROM Card.Card C


INNER JOIN Customer.Customer CU
ON C.CustomerID = CU.CustomerID


LEFT JOIN Card.CardLimit CL
ON C.CardID = CL.CardID
AND CL.EffectiveTo IS NULL


WHERE C.CardID = @CardID;



END TRY

BEGIN CATCH

THROW;

END CATCH

END;
GO
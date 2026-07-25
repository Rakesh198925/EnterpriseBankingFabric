/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Transactions
Procedure  : usp_GetTransactionSummary
Author     : Rakesh Soma
Purpose    : Get transaction summary for reporting and analytics
Technology : SQL Server 2019
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER PROCEDURE Transactions.usp_GetTransactionSummary
(
      @AccountID INT
    , @FromDate DATE = NULL
    , @ToDate DATE = NULL
)
AS
BEGIN

SET NOCOUNT ON;


BEGIN TRY


SELECT

    T.TransactionID,

    T.TransactionReference,

    T.AccountID,


    ---------------------------------------------------------
    -- Transaction Details
    ---------------------------------------------------------

    T.TransactionTypeID,

    TT.TransactionTypeCode,

    TT.TransactionTypeName,


    T.TransactionDate,

    T.ValueDate,


    T.Amount,

    T.CurrencyID,


    T.DebitCreditIndicator,


    CASE
        WHEN T.DebitCreditIndicator = 'D'
        THEN 'Debit'
        WHEN T.DebitCreditIndicator = 'C'
        THEN 'Credit'
        ELSE 'Unknown'
    END AS TransactionDirection,


    T.TransactionStatus,

    T.Channel,

    T.Description,


    ---------------------------------------------------------
    -- Detail Information
    ---------------------------------------------------------

    TD.MerchantName,

    TD.MerchantCategoryCode,

    TD.PaymentReference,

    TD.EndToEndReference,

    TD.RemittanceInformation,

    TD.AuthorizationCode,


    ---------------------------------------------------------
    -- Fees
    ---------------------------------------------------------

    TF.FeeType,

    TF.FeeAmount,


    ---------------------------------------------------------
    -- Audit Information
    ---------------------------------------------------------

    TA.ChangedBy AS LastStatusChangedBy,

    TA.ChangedDate AS LastStatusChangedDate



FROM Transactions.[Transaction] T



LEFT JOIN Master.TransactionTypeMaster TT

ON T.TransactionTypeID = TT.TransactionTypeID



LEFT JOIN Transactions.TransactionDetail TD

ON T.TransactionID = TD.TransactionID



LEFT JOIN Transactions.TransactionFee TF

ON T.TransactionID = TF.TransactionID



OUTER APPLY
(
    SELECT TOP 1

        ChangedBy,

        ChangedDate

    FROM Transactions.TransactionAudit

    WHERE TransactionID = T.TransactionID

    ORDER BY ChangedDate DESC

) TA



WHERE

T.AccountID = @AccountID


AND

(
    @FromDate IS NULL
    OR CAST(T.TransactionDate AS DATE) >= @FromDate
)


AND

(
    @ToDate IS NULL
    OR CAST(T.TransactionDate AS DATE) <= @ToDate
)



ORDER BY

T.TransactionDate DESC;



END TRY


BEGIN CATCH

THROW;


END CATCH


END;
GO
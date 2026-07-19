/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Transaction Analytics
View       : Transactions.vw_DailyTransactionReport
Author     : Rakesh Soma

Purpose:
    Daily transaction monitoring
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER VIEW Transactions.vw_DailyTransactionReport
AS


SELECT


CAST(T.TransactionDate AS DATE) AS TransactionDate,


TT.TransactionTypeName,


CM.CurrencyCode,


COUNT(T.TransactionID) AS TransactionCount,


SUM(T.Amount) AS TotalAmount,


SUM
(
CASE
    WHEN T.DebitCreditIndicator = 'D'
    THEN T.Amount
    ELSE 0
END
) AS DebitAmount,


SUM
(
CASE
    WHEN T.DebitCreditIndicator = 'C'
    THEN T.Amount
    ELSE 0
END
) AS CreditAmount



FROM Transactions.[Transaction] T


LEFT JOIN Master.TransactionTypeMaster TT

ON T.TransactionTypeID = TT.TransactionTypeID


LEFT JOIN Master.CurrencyMaster CM

ON T.CurrencyID = CM.CurrencyID



GROUP BY


CAST(T.TransactionDate AS DATE),

TT.TransactionTypeName,

CM.CurrencyCode;


GO
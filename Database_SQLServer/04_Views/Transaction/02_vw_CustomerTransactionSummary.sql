/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Transaction Analytics
View       : Transactions.vw_CustomerTransactionSummary
Author     : Rakesh Soma

Purpose:
    Customer transaction behaviour analysis
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER VIEW Transactions.vw_CustomerTransactionSummary
AS

SELECT


C.CustomerID,

C.CustomerNumber,

C.FirstName,

C.LastName,


COUNT(T.TransactionID) AS TotalTransactions,


SUM
(
CASE
    WHEN T.DebitCreditIndicator = 'D'
    THEN T.Amount
    ELSE 0
END
) AS TotalDebitAmount,


SUM
(
CASE
    WHEN T.DebitCreditIndicator = 'C'
    THEN T.Amount
    ELSE 0
END
) AS TotalCreditAmount,


AVG(T.Amount) AS AverageTransactionAmount,


MAX(T.TransactionDate) AS LastTransactionDate



FROM Customer.Customer C


INNER JOIN Account.Account A

ON C.CustomerID = A.CustomerID


INNER JOIN Transactions.[Transaction] T

ON A.AccountID = T.AccountID



GROUP BY

C.CustomerID,

C.CustomerNumber,

C.FirstName,

C.LastName;


GO
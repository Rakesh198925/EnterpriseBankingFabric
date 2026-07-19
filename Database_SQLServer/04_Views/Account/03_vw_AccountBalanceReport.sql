/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Account Analytics
View       : Account.vw_AccountBalanceReport
Author     : Rakesh Soma

Purpose:
    Daily account balance reporting
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER VIEW Account.vw_AccountBalanceReport
AS


SELECT


AB.AccountBalanceID,


A.AccountNumber,


C.CustomerNumber,


C.FirstName + ' ' + C.LastName AS CustomerName,


AB.BalanceDate,


AB.OpeningBalance,


AB.TotalCredits,


AB.TotalDebits,


AB.ClosingBalance,


AB.AvailableBalance,


AB.LedgerBalance,


A.AccountStatus,


CM.CurrencyCode



FROM Account.AccountBalance AB


INNER JOIN Account.Account A

ON AB.AccountID = A.AccountID


INNER JOIN Customer.Customer C

ON A.CustomerID = C.CustomerID


LEFT JOIN Master.CurrencyMaster CM

ON A.CurrencyID = CM.CurrencyID;



GO
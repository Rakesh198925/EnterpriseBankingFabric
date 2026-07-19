/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer Account Analytics
View       : Account.vw_CustomerAccountDetails
Author     : Rakesh Soma
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER VIEW Account.vw_CustomerAccountDetails
AS


SELECT


C.CustomerID,

C.CustomerNumber,

C.FirstName,

C.LastName,


A.AccountID,

A.AccountNumber,

A.IBAN,


AT.AccountTypeName,


A.AccountStatus,


A.OpenDate,


A.CurrentBalance,


A.AvailableBalance,


CM.CurrencyCode,


B.BranchName,


CASE

WHEN A.IsJointAccount = 1

THEN 'Joint Account'

ELSE 'Single Account'

END AS AccountOwnership



FROM Customer.Customer C


INNER JOIN Account.Account A

ON C.CustomerID = A.CustomerID


LEFT JOIN Master.AccountTypeMaster AT

ON A.AccountTypeID = AT.AccountTypeID


LEFT JOIN Master.CurrencyMaster CM

ON A.CurrencyID = CM.CurrencyID


LEFT JOIN Master.BranchMaster B

ON A.BranchID = B.BranchID;


GO
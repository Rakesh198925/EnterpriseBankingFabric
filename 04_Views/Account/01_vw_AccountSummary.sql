/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Account Analytics
View       : Account.vw_AccountSummary
Author     : Rakesh Soma

Purpose:
    Account level summary for reporting
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER VIEW Account.vw_AccountSummary
AS

SELECT

A.AccountID,
A.AccountNumber,
A.IBAN,

A.AccountName,

A.CustomerID,

C.CustomerNumber,

C.FirstName + ' ' + C.LastName AS CustomerName,


AT.AccountTypeCode,
AT.AccountTypeName,


CM.CurrencyCode,


B.BranchCode,
B.BranchName,


A.OpenDate,
A.CloseDate,


A.AccountStatus,


A.AvailableBalance,
A.CurrentBalance,
A.OverdraftLimit,


A.IsJointAccount,
A.IsActive,


A.CreatedDate,
A.CreatedBy


FROM Account.Account A


INNER JOIN Customer.Customer C
ON A.CustomerID = C.CustomerID


LEFT JOIN Master.AccountTypeMaster AT
ON A.AccountTypeID = AT.AccountTypeID


LEFT JOIN Master.CurrencyMaster CM
ON A.CurrencyID = CM.CurrencyID


LEFT JOIN Master.BranchMaster B
ON A.BranchID = B.BranchID;


GO
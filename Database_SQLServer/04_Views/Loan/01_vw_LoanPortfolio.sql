/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Loan Analytics
View       : Loan.vw_LoanPortfolio
Author     : Rakesh Soma

Purpose:
    Loan portfolio overview for analytics
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER VIEW Loan.vw_LoanPortfolio
AS

SELECT

L.LoanID,
L.LoanNumber,


C.CustomerID,
C.CustomerNumber,

C.FirstName + ' ' + C.LastName AS CustomerName,


LT.LoanTypeCode,
LT.LoanTypeName,


CM.CurrencyCode,


L.PrincipalAmount,

L.OutstandingAmount,


L.InterestRate,

L.LoanTermMonths,


L.StartDate,

L.MaturityDate,


L.LoanStatus,


CASE

WHEN L.OutstandingAmount = 0

THEN 'Closed'

WHEN L.MaturityDate < CAST(GETDATE() AS DATE)

THEN 'Overdue'

ELSE 'Active'

END AS LoanHealthStatus,


L.CreatedDate,
L.CreatedBy



FROM Loan.Loan L


INNER JOIN Customer.Customer C

ON L.CustomerID = C.CustomerID


LEFT JOIN Master.LoanTypeMaster LT

ON L.LoanTypeID = LT.LoanTypeID


LEFT JOIN Master.CurrencyMaster CM

ON L.CurrencyID = CM.CurrencyID;


GO
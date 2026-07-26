/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Loan Analytics
View       : Loan.vw_LoanCustomerSummary
Author     : Rakesh Soma

Purpose:
    Customer level loan summary
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER VIEW Loan.vw_LoanCustomerSummary
AS


SELECT


C.CustomerID,

C.CustomerNumber,

C.FirstName,

C.LastName,


COUNT(L.LoanID) AS TotalLoans,


SUM(L.PrincipalAmount) AS TotalLoanAmount,


SUM(L.OutstandingAmount) AS TotalOutstandingAmount,


AVG(L.InterestRate) AS AverageInterestRate,


MAX(L.StartDate) AS LatestLoanDate



FROM Customer.Customer C


LEFT JOIN Loan.Loan L

ON C.CustomerID = L.CustomerID


GROUP BY

C.CustomerID,

C.CustomerNumber,

C.FirstName,

C.LastName;


GO
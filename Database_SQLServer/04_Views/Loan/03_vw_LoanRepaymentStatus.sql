/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Loan Repayment Analytics
View       : Loan.vw_LoanRepaymentStatus
Author     : Rakesh Soma

Purpose:
    Loan repayment monitoring
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER VIEW Loan.vw_LoanRepaymentStatus
AS


SELECT


L.LoanID,

L.LoanNumber,


C.CustomerNumber,


C.FirstName + ' ' + C.LastName AS CustomerName,


RS.InstallmentNumber,


RS.DueDate,


RS.PrincipalAmount,


RS.InterestAmount,


RS.TotalAmount,


RS.OutstandingBalance,


RS.PaymentStatus,



CASE

WHEN RS.DueDate < CAST(GETDATE() AS DATE)
AND RS.PaymentStatus <> 'PAID'

THEN 'Overdue'


WHEN RS.PaymentStatus = 'PAID'

THEN 'Completed'


ELSE 'Upcoming'


END AS RepaymentStatus



FROM Loan.LoanRepaymentSchedule RS


INNER JOIN Loan.Loan L

ON RS.LoanID = L.LoanID


INNER JOIN Customer.Customer C

ON L.CustomerID = C.CustomerID;



GO
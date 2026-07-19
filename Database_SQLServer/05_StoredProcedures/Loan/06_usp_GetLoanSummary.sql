/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Loan
Procedure  : usp_GetLoanSummary
Author     : Rakesh Soma
Purpose    : Customer loan summary for reporting and Power BI
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER PROCEDURE Loan.usp_GetLoanSummary
(
      @LoanID INT
)
AS
BEGIN

SET NOCOUNT ON;


BEGIN TRY


SELECT

    L.LoanID,
    L.LoanNumber,

    L.CustomerID,

    C.FirstName + ' ' + C.LastName AS CustomerName,


    L.LoanTypeID,

    L.PrincipalAmount,

    L.OutstandingAmount,

    L.InterestRate,

    L.LoanTermMonths,

    L.StartDate,

    L.MaturityDate,

    L.LoanStatus,


    -----------------------------------------------------
    -- Payment Summary
    -----------------------------------------------------

    ISNULL
    (
        (
            SELECT SUM(PaymentAmount)
            FROM Loan.LoanPayment LP
            WHERE LP.LoanID = L.LoanID
              AND PaymentStatus = 'SUCCESS'
        ),
        0
    ) AS TotalPaid,


    -----------------------------------------------------
    -- Remaining Installments
    -----------------------------------------------------

    (
        SELECT COUNT(*)
        FROM Loan.LoanRepaymentSchedule RS
        WHERE RS.LoanID = L.LoanID
          AND RS.PaymentStatus <> 'PAID'
    ) AS PendingInstallments



FROM Loan.Loan L


INNER JOIN Customer.Customer C
ON L.CustomerID = C.CustomerID


WHERE L.LoanID = @LoanID;



END TRY

BEGIN CATCH

THROW;

END CATCH

END;
GO
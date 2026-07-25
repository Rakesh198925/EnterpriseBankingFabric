/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Loan
Procedure  : usp_RejectLoan
Author     : Rakesh Soma
Purpose    : Reject customer loan application
Technology : SQL Server 2019
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Loan.usp_RejectLoan
(
      @LoanApplicationID INT
    , @RejectionReason   NVARCHAR(500)
    , @RejectedBy        NVARCHAR(200)
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


BEGIN TRY

BEGIN TRANSACTION;


---------------------------------------------------------
-- Validate Application
---------------------------------------------------------

IF NOT EXISTS
(
    SELECT 1
    FROM Loan.LoanApplication
    WHERE LoanApplicationID = @LoanApplicationID
      AND ApplicationStatus = 'PENDING'
)
BEGIN
    THROW 60020,'Loan application cannot be rejected.',1;
END;



---------------------------------------------------------
-- Update Application Status
---------------------------------------------------------

UPDATE Loan.LoanApplication
SET
    ApplicationStatus = 'REJECTED',
    DecisionDate = CAST(GETDATE() AS DATE),
    DecisionBy = @RejectedBy,
    RejectionReason = @RejectionReason
WHERE LoanApplicationID = @LoanApplicationID;



COMMIT TRANSACTION;


SELECT
    @LoanApplicationID AS LoanApplicationID,
    'Loan application rejected successfully' AS Message;



END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK;

THROW;

END CATCH

END;
GO
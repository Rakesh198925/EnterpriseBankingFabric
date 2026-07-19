/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Loan
Procedure  : usp_ApproveLoan
Author     : Rakesh Soma
Purpose    : Approve loan application and create loan account
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER PROCEDURE Loan.usp_ApproveLoan
(
      @LoanApplicationID INT
    , @AccountID         INT
    , @ApprovedBy        NVARCHAR(200)
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
    THROW 60010,'Loan application not available for approval.',1;
END;



DECLARE 
        @CustomerID INT,
        @LoanTypeID INT,
        @Amount DECIMAL(18,2),
        @Rate DECIMAL(5,2),
        @Term INT;



SELECT
    @CustomerID = CustomerID,
    @LoanTypeID = LoanTypeID,
    @Amount = RequestedAmount,
    @Rate = RequestedInterestRate,
    @Term = RequestedTermMonths
FROM Loan.LoanApplication
WHERE LoanApplicationID = @LoanApplicationID;



---------------------------------------------------------
-- Update Application
---------------------------------------------------------

UPDATE Loan.LoanApplication
SET
    ApplicationStatus = 'APPROVED',
    DecisionDate = CAST(GETDATE() AS DATE),
    DecisionBy = @ApprovedBy
WHERE LoanApplicationID = @LoanApplicationID;



---------------------------------------------------------
-- Generate Loan Number
---------------------------------------------------------

DECLARE @LoanNumber VARCHAR(30);

SET @LoanNumber =
'LN' + FORMAT(NEXT VALUE FOR dbo.LoanNumberSequence,'000000');



---------------------------------------------------------
-- Create Loan
---------------------------------------------------------

INSERT INTO Loan.Loan
(
    LoanNumber,
    CustomerID,
    AccountID,
    LoanTypeID,
    PrincipalAmount,
    OutstandingAmount,
    InterestRate,
    LoanTermMonths,
    StartDate,
    LoanStatus,
    CreatedDate,
    CreatedBy
)
VALUES
(
    @LoanNumber,
    @CustomerID,
    @AccountID,
    @LoanTypeID,
    @Amount,
    @Amount,
    @Rate,
    @Term,
    CAST(GETDATE() AS DATE),
    'ACTIVE',
    SYSUTCDATETIME(),
    @ApprovedBy
);



DECLARE @LoanID INT;

SET @LoanID = SCOPE_IDENTITY();



---------------------------------------------------------
-- Status History
---------------------------------------------------------

INSERT INTO Loan.LoanStatusHistory
(
    LoanID,
    PreviousStatus,
    CurrentStatus,
    StatusReason,
    EffectiveFrom,
    ChangedBy,
    CreatedDate
)
VALUES
(
    @LoanID,
    'PENDING',
    'ACTIVE',
    'Loan approved',
    SYSUTCDATETIME(),
    @ApprovedBy,
    SYSUTCDATETIME()
);



COMMIT TRANSACTION;


SELECT
    @LoanID AS LoanID,
    @LoanNumber AS LoanNumber,
    'Loan approved successfully' AS Message;


END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK;

THROW;

END CATCH

END;
GO
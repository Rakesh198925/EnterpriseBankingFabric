/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Loan
Procedure  : usp_UpdateLoanStatus
Author     : Rakesh Soma
Purpose    : Update loan lifecycle status
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER PROCEDURE Loan.usp_UpdateLoanStatus
(
      @LoanID        INT
    , @NewStatus     VARCHAR(30)
    , @StatusReason  NVARCHAR(500)
    , @ChangedBy     NVARCHAR(200)
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


BEGIN TRY

BEGIN TRANSACTION;



DECLARE @PreviousStatus VARCHAR(30);



SELECT
    @PreviousStatus = LoanStatus
FROM Loan.Loan
WHERE LoanID = @LoanID;



IF @PreviousStatus IS NULL
BEGIN
    THROW 60040,'Invalid Loan ID.',1;
END;



---------------------------------------------------------
-- Update Loan
---------------------------------------------------------

UPDATE Loan.Loan
SET
    LoanStatus = @NewStatus,
    ModifiedDate = SYSUTCDATETIME(),
    ModifiedBy = @ChangedBy
WHERE LoanID = @LoanID;



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
    @PreviousStatus,
    @NewStatus,
    @StatusReason,
    SYSUTCDATETIME(),
    @ChangedBy,
    SYSUTCDATETIME()
);



COMMIT TRANSACTION;


SELECT
    @LoanID AS LoanID,
    'Loan status updated successfully' AS Message;



END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK;

THROW;

END CATCH

END;
GO
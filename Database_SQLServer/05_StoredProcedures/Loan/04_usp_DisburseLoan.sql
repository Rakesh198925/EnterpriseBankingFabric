/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Loan
Procedure  : usp_DisburseLoan
Author     : Rakesh Soma
Purpose    : Disburse approved loan amount
Technology : SQL Server 2019
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER PROCEDURE Loan.usp_DisburseLoan
(
      @LoanID       INT
    , @DisbursedBy  NVARCHAR(200)
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


BEGIN TRY

BEGIN TRANSACTION;



---------------------------------------------------------
-- Validate Loan
---------------------------------------------------------

IF NOT EXISTS
(
    SELECT 1
    FROM Loan.Loan
    WHERE LoanID = @LoanID
      AND LoanStatus = 'ACTIVE'
)
BEGIN
    THROW 60030,'Loan is not available for disbursement.',1;
END;



DECLARE @PreviousStatus VARCHAR(30);



SELECT
    @PreviousStatus = LoanStatus
FROM Loan.Loan
WHERE LoanID = @LoanID;



---------------------------------------------------------
-- Update Loan Status
---------------------------------------------------------

UPDATE Loan.Loan
SET
    LoanStatus = 'DISBURSED',
    ModifiedDate = SYSUTCDATETIME(),
    ModifiedBy = @DisbursedBy
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
    'DISBURSED',
    'Loan amount disbursed',
    SYSUTCDATETIME(),
    @DisbursedBy,
    SYSUTCDATETIME()
);



---------------------------------------------------------
-- Audit
---------------------------------------------------------

INSERT INTO Loan.LoanAudit
(
    LoanID,
    AuditAction,
    ChangedColumn,
    OldValue,
    NewValue,
    ChangedBy,
    ChangedDate,
    SourceSystem
)
VALUES
(
    @LoanID,
    'UPDATE',
    'LoanStatus',
    @PreviousStatus,
    'DISBURSED',
    @DisbursedBy,
    SYSUTCDATETIME(),
    'SQL Server'
);



COMMIT TRANSACTION;



SELECT
    @LoanID AS LoanID,
    'Loan disbursed successfully' AS Message;



END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK;

THROW;

END CATCH

END;
GO
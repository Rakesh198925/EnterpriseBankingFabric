/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Transactions
Procedure  : usp_ProcessDeposit
Author     : Rakesh Soma
Purpose    : Process account deposit transaction
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER PROCEDURE Transactions.usp_ProcessDeposit
(
      @TransactionID BIGINT
    , @ProcessedBy NVARCHAR(200)
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


BEGIN TRY

BEGIN TRANSACTION;


DECLARE 
      @AccountID INT
    , @Amount DECIMAL(18,2)
    , @OldStatus VARCHAR(30);



SELECT
    @AccountID = AccountID,
    @Amount = Amount,
    @OldStatus = TransactionStatus
FROM Transactions.[Transaction]
WHERE TransactionID = @TransactionID;



IF @AccountID IS NULL
BEGIN
    THROW 80010,'Invalid transaction.',1;
END;



---------------------------------------------------------
-- Update Account Balance
---------------------------------------------------------

UPDATE Account.Account
SET
    CurrentBalance = CurrentBalance + @Amount,
    AvailableBalance = AvailableBalance + @Amount,
    ModifiedDate = SYSUTCDATETIME(),
    ModifiedBy = @ProcessedBy
WHERE AccountID = @AccountID;



---------------------------------------------------------
-- Update Transaction
---------------------------------------------------------

UPDATE Transactions.[Transaction]
SET
    TransactionStatus = 'COMPLETED',
    ModifiedDate = SYSUTCDATETIME(),
    ModifiedBy = @ProcessedBy
WHERE TransactionID = @TransactionID;



---------------------------------------------------------
-- Audit
---------------------------------------------------------

INSERT INTO Transactions.TransactionAudit
(
    TransactionID,
    AuditAction,
    PreviousStatus,
    CurrentStatus,
    ChangedBy,
    ChangedDate,
    SourceSystem
)
VALUES
(
    @TransactionID,
    'DEPOSIT',
    @OldStatus,
    'COMPLETED',
    @ProcessedBy,
    SYSUTCDATETIME(),
    'SQL Server'
);



COMMIT TRANSACTION;


SELECT
    @TransactionID AS TransactionID,
    'Deposit completed successfully' AS Message;


END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK;

THROW;

END CATCH

END;
GO
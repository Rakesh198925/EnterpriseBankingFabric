/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Transactions
Procedure  : usp_ProcessWithdrawal
Author     : Rakesh Soma
Purpose    : Process account withdrawal transaction
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER PROCEDURE Transactions.usp_ProcessWithdrawal
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
    , @Balance DECIMAL(18,2)
    , @OldStatus VARCHAR(30);



SELECT

    @AccountID = T.AccountID,
    @Amount = T.Amount,
    @OldStatus = T.TransactionStatus

FROM Transactions.[Transaction] T

WHERE T.TransactionID = @TransactionID;



SELECT
    @Balance = CurrentBalance

FROM Account.Account

WHERE AccountID = @AccountID;



IF @Balance < @Amount
BEGIN
    THROW 80020,'Insufficient account balance.',1;
END;



---------------------------------------------------------
-- Debit Account
---------------------------------------------------------

UPDATE Account.Account

SET

    CurrentBalance = CurrentBalance - @Amount,
    AvailableBalance = AvailableBalance - @Amount,
    ModifiedDate = SYSUTCDATETIME(),
    ModifiedBy = @ProcessedBy

WHERE AccountID = @AccountID;



---------------------------------------------------------
-- Complete Transaction
---------------------------------------------------------

UPDATE Transactions.[Transaction]

SET

    TransactionStatus = 'COMPLETED',
    ModifiedDate = SYSUTCDATETIME(),
    ModifiedBy = @ProcessedBy

WHERE TransactionID = @TransactionID;



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
    'WITHDRAWAL',
    @OldStatus,
    'COMPLETED',
    @ProcessedBy,
    SYSUTCDATETIME(),
    'SQL Server'
);



COMMIT TRANSACTION;



SELECT
    @TransactionID AS TransactionID,
    'Withdrawal completed successfully' AS Message;



END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK;

THROW;

END CATCH

END;
GO
/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Transactions
Procedure  : usp_ProcessTransfer
Author     : Rakesh Soma
Purpose    : Process account to account transfer
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Transactions.usp_ProcessTransfer
(
      @DebitTransactionID  BIGINT
    , @CreditTransactionID BIGINT
    , @ProcessedBy NVARCHAR(200)
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


BEGIN TRY

BEGIN TRANSACTION;


DECLARE
      @DebitAccountID INT
    , @CreditAccountID INT
    , @DebitAmount DECIMAL(18,2)
    , @DebitBalance DECIMAL(18,2);



---------------------------------------------------------
-- Debit Transaction Details
---------------------------------------------------------

SELECT
    @DebitAccountID = AccountID,
    @DebitAmount = Amount

FROM Transactions.[Transaction]

WHERE TransactionID = @DebitTransactionID;



---------------------------------------------------------
-- Credit Transaction Details
---------------------------------------------------------

SELECT
    @CreditAccountID = AccountID

FROM Transactions.[Transaction]

WHERE TransactionID = @CreditTransactionID;



IF @DebitAccountID IS NULL
BEGIN
    THROW 80030,'Invalid debit transaction.',1;
END;


IF @CreditAccountID IS NULL
BEGIN
    THROW 80031,'Invalid credit transaction.',1;
END;



---------------------------------------------------------
-- Check Balance
---------------------------------------------------------

SELECT
    @DebitBalance = CurrentBalance

FROM Account.Account

WHERE AccountID = @DebitAccountID;



IF @DebitBalance < @DebitAmount
BEGIN
    THROW 80032,'Insufficient balance for transfer.',1;
END;



---------------------------------------------------------
-- Debit Account
---------------------------------------------------------

UPDATE Account.Account

SET

CurrentBalance = CurrentBalance - @DebitAmount,
AvailableBalance = AvailableBalance - @DebitAmount,
ModifiedDate = SYSUTCDATETIME(),
ModifiedBy = @ProcessedBy

WHERE AccountID = @DebitAccountID;



---------------------------------------------------------
-- Credit Account
---------------------------------------------------------

UPDATE Account.Account

SET

CurrentBalance = CurrentBalance + @DebitAmount,
AvailableBalance = AvailableBalance + @DebitAmount,
ModifiedDate = SYSUTCDATETIME(),
ModifiedBy = @ProcessedBy

WHERE AccountID = @CreditAccountID;



---------------------------------------------------------
-- Complete Transactions
---------------------------------------------------------

UPDATE Transactions.[Transaction]

SET

TransactionStatus = 'COMPLETED',
ModifiedDate = SYSUTCDATETIME(),
ModifiedBy = @ProcessedBy

WHERE TransactionID IN
(
 @DebitTransactionID,
 @CreditTransactionID
);



---------------------------------------------------------
-- Audit
---------------------------------------------------------

INSERT INTO Transactions.TransactionAudit
(
TransactionID,
AuditAction,
CurrentStatus,
ChangedBy,
ChangedDate,
SourceSystem
)
VALUES
(
@DebitTransactionID,
'TRANSFER_DEBIT',
'COMPLETED',
@ProcessedBy,
SYSUTCDATETIME(),
'SQL Server'
),
(
@CreditTransactionID,
'TRANSFER_CREDIT',
'COMPLETED',
@ProcessedBy,
SYSUTCDATETIME(),
'SQL Server'
);



COMMIT TRANSACTION;


SELECT
'Transfer completed successfully' AS Message;



END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK;

THROW;

END CATCH

END;
GO
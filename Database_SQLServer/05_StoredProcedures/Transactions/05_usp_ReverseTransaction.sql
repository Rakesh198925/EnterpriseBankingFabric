/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Transactions
Procedure  : usp_ReverseTransaction
Author     : Rakesh Soma
Purpose    : Reverse completed transaction
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER PROCEDURE Transactions.usp_ReverseTransaction
(
      @TransactionID BIGINT
    , @Reason NVARCHAR(500)
    , @ReversedBy NVARCHAR(200)
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


BEGIN TRY

BEGIN TRANSACTION;


DECLARE
    @OldStatus VARCHAR(30),
    @AccountID INT,
    @Amount DECIMAL(18,2);



SELECT

    @OldStatus = TransactionStatus,
    @AccountID = AccountID,
    @Amount = Amount

FROM Transactions.[Transaction]

WHERE TransactionID = @TransactionID;



IF @OldStatus IS NULL
BEGIN
    THROW 80040,'Invalid transaction.',1;
END;



IF @OldStatus <> 'COMPLETED'
BEGIN
    THROW 80041,'Only completed transactions can be reversed.',1;
END;



---------------------------------------------------------
-- Reverse Balance
---------------------------------------------------------

UPDATE Account.Account

SET

CurrentBalance =
CASE
WHEN EXISTS
(
 SELECT 1
 FROM Transactions.[Transaction]
 WHERE TransactionID=@TransactionID
 AND DebitCreditIndicator='D'
)
THEN CurrentBalance + @Amount

ELSE CurrentBalance - @Amount

END,


AvailableBalance =
CASE
WHEN EXISTS
(
 SELECT 1
 FROM Transactions.[Transaction]
 WHERE TransactionID=@TransactionID
 AND DebitCreditIndicator='D'
)
THEN AvailableBalance + @Amount

ELSE AvailableBalance - @Amount

END

WHERE AccountID=@AccountID;



---------------------------------------------------------
-- Update Transaction
---------------------------------------------------------

UPDATE Transactions.[Transaction]

SET

TransactionStatus='REVERSED',
ModifiedDate=SYSUTCDATETIME(),
ModifiedBy=@ReversedBy

WHERE TransactionID=@TransactionID;



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
'REVERSAL',
@OldStatus,
'REVERSED',
@ReversedBy,
SYSUTCDATETIME(),
'SQL Server'
);



COMMIT TRANSACTION;


SELECT
@TransactionID AS TransactionID,
'Transaction reversed successfully' AS Message;



END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK;

THROW;

END CATCH

END;
GO
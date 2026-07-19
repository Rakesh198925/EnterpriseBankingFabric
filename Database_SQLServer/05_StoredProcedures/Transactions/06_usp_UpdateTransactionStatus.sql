/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Transactions
Procedure  : usp_UpdateTransactionStatus
Author     : Rakesh Soma
Purpose    : Update transaction lifecycle status
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER PROCEDURE Transactions.usp_UpdateTransactionStatus
(
      @TransactionID BIGINT
    , @NewStatus VARCHAR(30)
    , @ChangedBy NVARCHAR(200)
)
AS
BEGIN

SET NOCOUNT ON;


BEGIN TRY


DECLARE @OldStatus VARCHAR(30);



SELECT

@OldStatus = TransactionStatus

FROM Transactions.[Transaction]

WHERE TransactionID=@TransactionID;



IF @OldStatus IS NULL
BEGIN
    THROW 80050,'Transaction not found.',1;
END;



UPDATE Transactions.[Transaction]

SET

TransactionStatus=@NewStatus,
ModifiedDate=SYSUTCDATETIME(),
ModifiedBy=@ChangedBy

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
'STATUS_UPDATE',
@OldStatus,
@NewStatus,
@ChangedBy,
SYSUTCDATETIME(),
'SQL Server'
);



SELECT
@TransactionID AS TransactionID,
'Transaction status updated successfully' AS Message;



END TRY

BEGIN CATCH

THROW;

END CATCH

END;
GO
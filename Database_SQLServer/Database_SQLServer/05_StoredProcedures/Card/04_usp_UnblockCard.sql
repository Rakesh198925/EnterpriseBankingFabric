/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Card
Procedure  : usp_UnblockCard
Author     : Rakesh Soma
Purpose    : Unblock previously blocked card
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER PROCEDURE Card.usp_UnblockCard
(
      @CardID        INT
    , @UnblockReason NVARCHAR(500)
    , @UnblockedBy   NVARCHAR(200)
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


BEGIN TRY

BEGIN TRANSACTION;


DECLARE @PreviousStatus VARCHAR(30);


SELECT
    @PreviousStatus = CardStatus
FROM Card.Card
WHERE CardID = @CardID;



IF @PreviousStatus IS NULL
BEGIN
    THROW 70030,'Invalid card.',1;
END;



IF @PreviousStatus <> 'BLOCKED'
BEGIN
    THROW 70031,'Only blocked cards can be unblocked.',1;
END;



---------------------------------------------------------
-- Update Card
---------------------------------------------------------

UPDATE Card.Card
SET
    CardStatus = 'ACTIVE'
WHERE CardID = @CardID;



---------------------------------------------------------
-- Audit
---------------------------------------------------------

INSERT INTO Card.CardAudit
(
    CardID,
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
    @CardID,
    'UPDATE',
    'CardStatus',
    @PreviousStatus,
    'ACTIVE',
    @UnblockedBy,
    SYSUTCDATETIME(),
    'SQL Server'
);



INSERT INTO Card.CardAudit
(
    CardID,
    AuditAction,
    ChangedColumn,
    NewValue,
    ChangedBy,
    ChangedDate,
    SourceSystem
)
VALUES
(
    @CardID,
    'COMMENT',
    'UnblockReason',
    @UnblockReason,
    @UnblockedBy,
    SYSUTCDATETIME(),
    'SQL Server'
);



COMMIT TRANSACTION;


SELECT
    @CardID AS CardID,
    'Card unblocked successfully' AS Message;


END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK;

THROW;

END CATCH

END;
GO
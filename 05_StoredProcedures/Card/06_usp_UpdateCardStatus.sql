/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Card
Procedure  : usp_UpdateCardStatus
Author     : Rakesh Soma
Purpose    : Update card lifecycle status
Technology : SQL Server 2019
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Card.usp_UpdateCardStatus
(
      @CardID          INT
    , @NewStatus       VARCHAR(30)
    , @StatusReason    NVARCHAR(500)
    , @ChangedBy       NVARCHAR(200)
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
    THROW 70050,'Invalid card.',1;
END;



---------------------------------------------------------
-- Update Card Status
---------------------------------------------------------

UPDATE Card.Card
SET
    CardStatus = @NewStatus
WHERE CardID = @CardID;



---------------------------------------------------------
-- Audit Status Change
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
    @NewStatus,
    @ChangedBy,
    SYSUTCDATETIME(),
    'SQL Server'
);



---------------------------------------------------------
-- Store Reason
---------------------------------------------------------

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
    'StatusReason',
    @StatusReason,
    @ChangedBy,
    SYSUTCDATETIME(),
    'SQL Server'
);



COMMIT TRANSACTION;


SELECT
    @CardID AS CardID,
    'Card status updated successfully' AS Message;


END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK;

THROW;

END CATCH

END;
GO
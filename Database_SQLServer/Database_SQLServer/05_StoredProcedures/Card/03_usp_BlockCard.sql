/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Card
Procedure  : usp_BlockCard
Author     : Rakesh Soma
Purpose    : Block card for fraud/lost/stolen/compliance reasons
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Card.usp_BlockCard
(
      @CardID        INT
    , @BlockReason   NVARCHAR(500)
    , @BlockedBy     NVARCHAR(200)
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
    THROW 70020,'Invalid card.',1;
END;



---------------------------------------------------------
-- Update Card Status
---------------------------------------------------------

UPDATE Card.Card
SET
    CardStatus = 'BLOCKED'
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
    'BLOCKED',
    @BlockedBy,
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
    'BlockReason',
    @BlockReason,
    @BlockedBy,
    SYSUTCDATETIME(),
    'SQL Server'
);



COMMIT TRANSACTION;


SELECT
    @CardID AS CardID,
    'Card blocked successfully' AS Message;


END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK;

THROW;

END CATCH

END;
GO
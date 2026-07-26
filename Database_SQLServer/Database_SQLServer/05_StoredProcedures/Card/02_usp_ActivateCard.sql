/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Card
Procedure  : usp_ActivateCard
Author     : Rakesh Soma
Purpose    : Activate issued card
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER PROCEDURE Card.usp_ActivateCard
(
      @CardID       INT
    , @ActivatedBy  NVARCHAR(200)
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


BEGIN TRY

BEGIN TRANSACTION;


DECLARE @OldStatus VARCHAR(30);



SELECT
    @OldStatus = CardStatus
FROM Card.Card
WHERE CardID = @CardID;



IF @OldStatus IS NULL
BEGIN
    THROW 70010,'Invalid card.',1;
END;



UPDATE Card.Card
SET
    CardStatus = 'ACTIVE'
WHERE CardID = @CardID;



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
    @OldStatus,
    'ACTIVE',
    @ActivatedBy,
    SYSUTCDATETIME(),
    'SQL Server'
);



COMMIT TRANSACTION;


SELECT
    @CardID AS CardID,
    'Card activated successfully' AS Message;


END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK;

THROW;

END CATCH

END;
GO
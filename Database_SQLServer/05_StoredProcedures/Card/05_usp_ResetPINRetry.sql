/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Card
Procedure  : usp_ResetPINRetry
Author     : Rakesh Soma
Purpose    : Maintain PIN reset history after customer verification
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER PROCEDURE Card.usp_ResetPINRetry
(
      @CardID       INT
    , @ChangeChannel VARCHAR(50)
    , @ChangedBy    NVARCHAR(200)
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


BEGIN TRY

BEGIN TRANSACTION;



---------------------------------------------------------
-- Validate Card
---------------------------------------------------------

IF NOT EXISTS
(
    SELECT 1
    FROM Card.Card
    WHERE CardID = @CardID
)
BEGIN
    THROW 70040,'Invalid card.',1;
END;



---------------------------------------------------------
-- Insert PIN History
---------------------------------------------------------

INSERT INTO Card.CardPINHistory
(
    CardID,
    PINChangedDate,
    ChangedBy,
    ChangeChannel,
    CreatedDate
)
VALUES
(
    @CardID,
    SYSUTCDATETIME(),
    @ChangedBy,
    @ChangeChannel,
    SYSUTCDATETIME()
);



---------------------------------------------------------
-- Audit
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
    'UPDATE',
    'PIN',
    'RESET',
    @ChangedBy,
    SYSUTCDATETIME(),
    'SQL Server'
);



COMMIT TRANSACTION;


SELECT
    @CardID AS CardID,
    'PIN reset completed successfully' AS Message;


END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK;

THROW;

END CATCH

END;
GO
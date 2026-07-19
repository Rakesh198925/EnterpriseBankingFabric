/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Account
Procedure  : usp_FreezeAccount
Author     : Rakesh Soma
Purpose    : Freeze an account for AML/Fraud/Compliance reasons
Technology : SQL Server 2019
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Account.usp_FreezeAccount
(
      @AccountID      INT
    , @FreezeReason   NVARCHAR(500)
    , @FrozenBy       NVARCHAR(200)
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


BEGIN TRY

    BEGIN TRANSACTION;


    ---------------------------------------------------------
    -- Validate Account
    ---------------------------------------------------------

    IF NOT EXISTS
    (
        SELECT 1
        FROM Account.Account
        WHERE AccountID = @AccountID
          AND IsActive = 1
    )
    BEGIN
        THROW 50020,'Invalid or inactive account.',1;
    END;



    DECLARE @PreviousStatus VARCHAR(20);


    SELECT
        @PreviousStatus = AccountStatus
    FROM Account.Account
    WHERE AccountID = @AccountID;



    ---------------------------------------------------------
    -- Freeze Account
    ---------------------------------------------------------

    UPDATE Account.Account
    SET
        AccountStatus = 'FROZEN',
        ModifiedDate = SYSUTCDATETIME(),
        ModifiedBy = @FrozenBy
    WHERE AccountID = @AccountID;



    ---------------------------------------------------------
    -- Status History
    ---------------------------------------------------------

    INSERT INTO Account.AccountStatusHistory
    (
        AccountID,
        PreviousStatus,
        CurrentStatus,
        StatusReason,
        EffectiveFrom,
        ChangedBy,
        CreatedDate
    )
    VALUES
    (
        @AccountID,
        @PreviousStatus,
        'FROZEN',
        @FreezeReason,
        SYSUTCDATETIME(),
        @FrozenBy,
        SYSUTCDATETIME()
    );



    ---------------------------------------------------------
    -- Audit
    ---------------------------------------------------------

    INSERT INTO Account.AccountAudit
    (
        AccountID,
        AuditAction,
        ChangedColumn,
        OldValue,
        NewValue,
        ChangedBy,
        SourceSystem
    )
    VALUES
    (
        @AccountID,
        'UPDATE',
        'AccountStatus',
        @PreviousStatus,
        'FROZEN',
        @FrozenBy,
        'SQL Server'
    );


    COMMIT TRANSACTION;


    SELECT
        @AccountID AS AccountID,
        'Account frozen successfully' AS Message;


END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;

END CATCH

END;
GO
/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Account
Procedure  : usp_UnfreezeAccount
Author     : Rakesh Soma
Purpose    : Unfreeze a frozen customer bank account
Technology : SQL Server 2019
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Account.usp_UnfreezeAccount
(
      @AccountID        INT
    , @UnfreezeReason   NVARCHAR(500)
    , @UnfrozenBy       NVARCHAR(200)
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
          AND AccountStatus = 'FROZEN'
    )
    BEGIN
        THROW 50030,'Account is not in frozen status.',1;
    END;


    DECLARE @PreviousStatus VARCHAR(20);


    SELECT 
        @PreviousStatus = AccountStatus
    FROM Account.Account
    WHERE AccountID = @AccountID;



    ---------------------------------------------------------
    -- Update Account Status
    ---------------------------------------------------------

    UPDATE Account.Account
    SET
        AccountStatus = 'ACTIVE',
        IsActive = 1,
        ModifiedDate = SYSUTCDATETIME(),
        ModifiedBy = @UnfrozenBy
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
        'ACTIVE',
        @UnfreezeReason,
        SYSUTCDATETIME(),
        @UnfrozenBy,
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
        'ACTIVE',
        @UnfrozenBy,
        'SQL Server'
    );


    COMMIT TRANSACTION;


    SELECT
        @AccountID AS AccountID,
        'Account unfrozen successfully' AS Message;


END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;

END CATCH

END;
GO
/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Account
Procedure  : usp_CloseAccount
Author     : Rakesh Soma
Purpose    : Close an existing customer bank account
Technology : SQL Server 2019
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Account.usp_CloseAccount
(
      @AccountID     INT
    , @CloseReason   NVARCHAR(500)
    , @ClosedBy      NVARCHAR(200)
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
        THROW 50010,'Invalid or inactive account.',1;
    END;


    ---------------------------------------------------------
    -- Validate Balance
    ---------------------------------------------------------

    IF EXISTS
    (
        SELECT 1
        FROM Account.Account
        WHERE AccountID = @AccountID
          AND CurrentBalance <> 0
    )
    BEGIN
        THROW 50011,'Account balance must be zero before closure.',1;
    END;


    DECLARE @PreviousStatus VARCHAR(20);


    SELECT 
        @PreviousStatus = AccountStatus
    FROM Account.Account
    WHERE AccountID = @AccountID;


    ---------------------------------------------------------
    -- Update Account
    ---------------------------------------------------------

    UPDATE Account.Account
    SET
        AccountStatus = 'CLOSED',
        CloseDate = CAST(GETDATE() AS DATE),
        IsActive = 0,
        ModifiedDate = SYSUTCDATETIME(),
        ModifiedBy = @ClosedBy
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
        'CLOSED',
        @CloseReason,
        SYSUTCDATETIME(),
        @ClosedBy,
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
        'CLOSED',
        @ClosedBy,
        'SQL Server'
    );


    COMMIT TRANSACTION;


    SELECT
        @AccountID AS AccountID,
        'Account closed successfully' AS Message;


END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;

END CATCH

END;
GO
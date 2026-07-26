/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Account
Procedure  : usp_UpdateAccountBalance
Author     : Rakesh Soma
Purpose    : Update account balance after financial transactions
Technology : SQL Server 2019
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Account.usp_UpdateAccountBalance
(
      @AccountID        INT
    , @CreditAmount     DECIMAL(18,2) = 0
    , @DebitAmount      DECIMAL(18,2) = 0
    , @UpdatedBy        NVARCHAR(200)
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
          AND AccountStatus = 'ACTIVE'
    )
    BEGIN
        THROW 50040,'Account is not active.',1;
    END;



    DECLARE @CurrentBalance DECIMAL(18,2);


    SELECT
        @CurrentBalance = CurrentBalance
    FROM Account.Account
    WHERE AccountID = @AccountID;



    IF (@DebitAmount > @CurrentBalance)
    BEGIN
        THROW 50041,'Insufficient account balance.',1;
    END;



    ---------------------------------------------------------
    -- Update Account
    ---------------------------------------------------------

    UPDATE Account.Account
    SET
        CurrentBalance = CurrentBalance + @CreditAmount - @DebitAmount,
        AvailableBalance = AvailableBalance + @CreditAmount - @DebitAmount,
        ModifiedDate = SYSUTCDATETIME(),
        ModifiedBy = @UpdatedBy
    WHERE AccountID = @AccountID;



    ---------------------------------------------------------
    -- Daily Balance Snapshot
    ---------------------------------------------------------

    INSERT INTO Account.AccountBalance
    (
        AccountID,
        BalanceDate,
        OpeningBalance,
        TotalCredits,
        TotalDebits,
        ClosingBalance,
        AvailableBalance,
        LedgerBalance,
        CreatedDate
    )
    SELECT
        AccountID,
        CAST(GETDATE() AS DATE),
        @CurrentBalance,
        @CreditAmount,
        @DebitAmount,
        CurrentBalance,
        AvailableBalance,
        CurrentBalance,
        SYSUTCDATETIME()
    FROM Account.Account
    WHERE AccountID = @AccountID;



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
        'Balance',
        CAST(@CurrentBalance AS NVARCHAR),
        CAST(@CurrentBalance + @CreditAmount - @DebitAmount AS NVARCHAR),
        @UpdatedBy,
        'SQL Server'
    );


    COMMIT TRANSACTION;


    SELECT
        @AccountID AS AccountID,
        'Balance updated successfully' AS Message;



END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;

END CATCH

END;
GO
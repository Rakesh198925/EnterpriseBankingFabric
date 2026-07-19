/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Account
Procedure  : usp_UpdateTransactionLimit
Author     : Rakesh Soma
Purpose    : Maintain account transaction limits
Technology : SQL Server 2019
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Account.usp_UpdateTransactionLimit
(
      @AccountID                 INT
    , @DailyATMWithdrawalLimit   DECIMAL(18,2)
    , @DailyPOSLimit             DECIMAL(18,2)
    , @DailyOnlineTransferLimit  DECIMAL(18,2)
    , @DailyCashDepositLimit     DECIMAL(18,2)
    , @CurrencyCode              CHAR(3)
    , @UpdatedBy                 NVARCHAR(200)
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


BEGIN TRY

    BEGIN TRANSACTION;



    IF NOT EXISTS
    (
        SELECT 1
        FROM Account.Account
        WHERE AccountID = @AccountID
    )
    BEGIN
        THROW 50050,'Invalid account.',1;
    END;



    ---------------------------------------------------------
    -- Expire Previous Limit
    ---------------------------------------------------------

    UPDATE Account.AccountTransactionLimit
    SET
        EffectiveTo = CAST(GETDATE() AS DATE)
    WHERE AccountID = @AccountID
      AND EffectiveTo IS NULL;



    ---------------------------------------------------------
    -- Insert New Limit
    ---------------------------------------------------------

    INSERT INTO Account.AccountTransactionLimit
    (
        AccountID,
        DailyATMWithdrawalLimit,
        DailyPOSLimit,
        DailyOnlineTransferLimit,
        DailyCashDepositLimit,
        CurrencyCode,
        EffectiveFrom,
        CreatedDate
    )
    VALUES
    (
        @AccountID,
        @DailyATMWithdrawalLimit,
        @DailyPOSLimit,
        @DailyOnlineTransferLimit,
        @DailyCashDepositLimit,
        @CurrencyCode,
        CAST(GETDATE() AS DATE),
        SYSUTCDATETIME()
    );



    COMMIT TRANSACTION;


    SELECT
        @AccountID AS AccountID,
        'Transaction limits updated successfully' AS Message;


END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;

END CATCH

END;
GO
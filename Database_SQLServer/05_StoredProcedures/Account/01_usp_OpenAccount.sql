/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Account
Procedure  : usp_OpenAccount
Author     : Rakesh Soma
Purpose    : Open a new customer bank account
Technology : SQL Server 2019
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Account.usp_OpenAccount
(
      @AccountNumber      VARCHAR(30)
    , @IBAN               VARCHAR(50)
    , @AccountName        NVARCHAR(200)
    , @CustomerID         INT
    , @BranchID           INT
    , @AccountTypeID      INT
    , @CurrencyID         INT
    , @OpeningBalance     DECIMAL(18,2)
    , @IsJointAccount     BIT = 0
    , @CreatedBy          NVARCHAR(200)
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY

    BEGIN TRANSACTION;


    ---------------------------------------------------------
    -- Validate Customer
    ---------------------------------------------------------

    IF NOT EXISTS
    (
        SELECT 1
        FROM Customer.Customer
        WHERE CustomerID = @CustomerID
          AND IsActive = 1
    )
    BEGIN
        THROW 50001,'Invalid Customer.',1;
    END;


    ---------------------------------------------------------
    -- Validate Account Number
    ---------------------------------------------------------

    IF EXISTS
    (
        SELECT 1
        FROM Account.Account
        WHERE AccountNumber = @AccountNumber
    )
    BEGIN
        THROW 50002,'Account Number already exists.',1;
    END;


    ---------------------------------------------------------
    -- Create Account
    ---------------------------------------------------------

    INSERT INTO Account.Account
    (
        AccountNumber,
        IBAN,
        AccountName,
        CustomerID,
        BranchID,
        AccountTypeID,
        CurrencyID,
        OpenDate,
        AccountStatus,
        AvailableBalance,
        CurrentBalance,
        OverdraftLimit,
        IsJointAccount,
        IsActive,
        CreatedDate,
        CreatedBy
    )
    VALUES
    (
        @AccountNumber,
        @IBAN,
        @AccountName,
        @CustomerID,
        @BranchID,
        @AccountTypeID,
        @CurrencyID,
        CAST(GETDATE() AS DATE),
        'ACTIVE',
        @OpeningBalance,
        @OpeningBalance,
        0,
        @IsJointAccount,
        1,
        SYSUTCDATETIME(),
        @CreatedBy
    );


    DECLARE @AccountID INT;

    SET @AccountID = SCOPE_IDENTITY();


    ---------------------------------------------------------
    -- Create Account Holder
    ---------------------------------------------------------

    INSERT INTO Account.AccountHolder
    (
        AccountID,
        CustomerID,
        HolderType,
        OwnershipPercentage,
        StartDate,
        IsPrimaryHolder,
        IsActive,
        CreatedDate,
        CreatedBy
    )
    VALUES
    (
        @AccountID,
        @CustomerID,
        'PRIMARY',
        100,
        CAST(GETDATE() AS DATE),
        1,
        1,
        SYSUTCDATETIME(),
        @CreatedBy
    );


    ---------------------------------------------------------
    -- Create Initial Balance
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
    VALUES
    (
        @AccountID,
        CAST(GETDATE() AS DATE),
        @OpeningBalance,
        0,
        0,
        @OpeningBalance,
        @OpeningBalance,
        @OpeningBalance,
        SYSUTCDATETIME()
    );


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
        NULL,
        'ACTIVE',
        'Account opened',
        SYSUTCDATETIME(),
        @CreatedBy,
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
        'CREATE',
        'AccountStatus',
        NULL,
        'ACTIVE',
        @CreatedBy,
        'SQL Server'
    );


    COMMIT TRANSACTION;


    SELECT
        @AccountID AS AccountID,
        @AccountNumber AS AccountNumber,
        'Account opened successfully' AS Message;


END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;

END CATCH

END;
GO
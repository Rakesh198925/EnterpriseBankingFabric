/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Account
Procedure  : usp_AddJointHolder
Author     : Rakesh Soma
Purpose    : Add a joint holder to an existing account
Technology : SQL Server 2019
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Account.usp_AddJointHolder
(
      @AccountID              INT
    , @CustomerID             INT
    , @OwnershipPercentage    DECIMAL(5,2)
    , @AddedBy                NVARCHAR(200)
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
        THROW 50060,'Invalid or inactive account.',1;
    END;



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
        THROW 50061,'Invalid customer.',1;
    END;



    ---------------------------------------------------------
    -- Check Existing Holder
    ---------------------------------------------------------

    IF EXISTS
    (
        SELECT 1
        FROM Account.AccountHolder
        WHERE AccountID = @AccountID
          AND CustomerID = @CustomerID
          AND IsActive = 1
    )
    BEGIN
        THROW 50062,'Customer already exists as account holder.',1;
    END;



    ---------------------------------------------------------
    -- Validate Ownership
    ---------------------------------------------------------

    IF
    (
        SELECT ISNULL(SUM(OwnershipPercentage),0)
        FROM Account.AccountHolder
        WHERE AccountID = @AccountID
          AND IsActive = 1
    ) + @OwnershipPercentage > 100
    BEGIN
        THROW 50063,'Ownership percentage cannot exceed 100%.',1;
    END;



    ---------------------------------------------------------
    -- Insert Joint Holder
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
        'JOINT',
        @OwnershipPercentage,
        CAST(GETDATE() AS DATE),
        0,
        1,
        SYSUTCDATETIME(),
        @AddedBy
    );



    ---------------------------------------------------------
    -- Update Account
    ---------------------------------------------------------

    UPDATE Account.Account
    SET
        IsJointAccount = 1,
        ModifiedDate = SYSUTCDATETIME(),
        ModifiedBy = @AddedBy
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
        'ADD',
        'JointHolder',
        NULL,
        CAST(@CustomerID AS NVARCHAR),
        @AddedBy,
        'SQL Server'
    );



    COMMIT TRANSACTION;


    SELECT
        @AccountID AS AccountID,
        @CustomerID AS JointHolderCustomerID,
        'Joint holder added successfully' AS Message;



END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;

END CATCH

END;
GO
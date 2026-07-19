/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Transactions
Procedure  : usp_CreateTransaction
Author     : Rakesh Soma
Purpose    : Create banking transaction with audit tracking
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Transactions.usp_CreateTransaction
(
      @TransactionReference VARCHAR(50)
    , @AccountID INT
    , @TransactionTypeID INT
    , @Amount DECIMAL(18,2)
    , @CurrencyID INT
    , @DebitCreditIndicator CHAR(1)
    , @Channel VARCHAR(30)
    , @Description NVARCHAR(1000)
    , @CreatedBy NVARCHAR(200)
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
    THROW 80001,'Invalid or inactive account.',1;
END;



---------------------------------------------------------
-- Duplicate Transaction Check
---------------------------------------------------------

IF EXISTS
(
    SELECT 1
    FROM Transactions.[Transaction]
    WHERE TransactionReference = @TransactionReference
)
BEGIN
    THROW 80002,'Transaction reference already exists.',1;
END;



---------------------------------------------------------
-- Insert Transaction
---------------------------------------------------------

INSERT INTO Transactions.[Transaction]
(
    TransactionReference,
    AccountID,
    TransactionTypeID,
    TransactionDate,
    ValueDate,
    Amount,
    CurrencyID,
    DebitCreditIndicator,
    TransactionStatus,
    Channel,
    Description,
    CreatedDate,
    CreatedBy
)
VALUES
(
    @TransactionReference,
    @AccountID,
    @TransactionTypeID,
    SYSUTCDATETIME(),
    CAST(GETDATE() AS DATE),
    @Amount,
    @CurrencyID,
    @DebitCreditIndicator,
    'PENDING',
    @Channel,
    @Description,
    SYSUTCDATETIME(),
    @CreatedBy
);



DECLARE @TransactionID BIGINT;

SET @TransactionID = SCOPE_IDENTITY();



---------------------------------------------------------
-- Audit
---------------------------------------------------------

INSERT INTO Transactions.TransactionAudit
(
    TransactionID,
    AuditAction,
    CurrentStatus,
    ChangedBy,
    ChangedDate,
    SourceSystem
)
VALUES
(
    @TransactionID,
    'CREATE',
    'PENDING',
    @CreatedBy,
    SYSUTCDATETIME(),
    'SQL Server'
);



COMMIT TRANSACTION;


SELECT
    @TransactionID AS TransactionID,
    'Transaction created successfully' AS Message;



END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK;

THROW;

END CATCH

END;
GO
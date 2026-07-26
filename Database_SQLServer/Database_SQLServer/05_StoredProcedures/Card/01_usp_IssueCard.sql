/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Card
Procedure  : usp_IssueCard
Author     : Rakesh Soma
Purpose    : Issue new debit/credit card for customer account
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Card.usp_IssueCard
(
      @CardNumber              VARCHAR(30)
    , @AccountID               INT
    , @CustomerID              INT
    , @CardTypeID              INT
    , @CardBrand               VARCHAR(30)
    , @CardHolderName          NVARCHAR(200)
    , @ExpiryDate              DATE
    , @CreatedBy               NVARCHAR(200)
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
    THROW 70001,'Invalid or inactive account.',1;
END;



---------------------------------------------------------
-- Duplicate Card Check
---------------------------------------------------------

IF EXISTS
(
    SELECT 1
    FROM Card.Card
    WHERE CardNumber = @CardNumber
)
BEGIN
    THROW 70002,'Card number already exists.',1;
END;



---------------------------------------------------------
-- Insert Card
---------------------------------------------------------

INSERT INTO Card.Card
(
    CardNumber,
    AccountID,
    CustomerID,
    CardTypeID,
    CardBrand,
    CardHolderName,
    IssueDate,
    ExpiryDate,
    CardStatus,
    ContactlessEnabled,
    InternationalUsageEnabled,
    OnlineUsageEnabled,
    ATMUsageEnabled,
    CreatedDate
)
VALUES
(
    @CardNumber,
    @AccountID,
    @CustomerID,
    @CardTypeID,
    @CardBrand,
    @CardHolderName,
    CAST(GETDATE() AS DATE),
    @ExpiryDate,
    'INACTIVE',
    1,
    1,
    1,
    1,
    SYSUTCDATETIME()
);



DECLARE @CardID INT;

SET @CardID = SCOPE_IDENTITY();



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
    'INSERT',
    'CardStatus',
    'INACTIVE',
    @CreatedBy,
    SYSUTCDATETIME(),
    'SQL Server'
);



COMMIT TRANSACTION;


SELECT
    @CardID AS CardID,
    'Card issued successfully' AS Message;


END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK;

THROW;

END CATCH

END;
GO
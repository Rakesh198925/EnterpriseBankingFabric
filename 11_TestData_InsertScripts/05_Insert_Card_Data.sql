/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Card Test Data
Script     : 05_Insert_Card_Data.sql
Author     : Rakesh Soma
Purpose    : Insert Card domain sample data
******************************************************************************/

USE BankingERP;
GO

SET NOCOUNT ON;

BEGIN TRY

BEGIN TRANSACTION;


DECLARE
@CustomerID INT,
@AccountID INT,
@CardTypeID INT,
@CurrencyID INT,
@CardID INT;


---------------------------------------------------------
-- Get Customer
---------------------------------------------------------

SELECT TOP 1
@CustomerID = CustomerID
FROM Customer.Customer
WHERE CustomerNumber='CUST100001';



---------------------------------------------------------
-- Get Account
---------------------------------------------------------

SELECT TOP 1
@AccountID = AccountID
FROM Account.Account
WHERE CustomerID=@CustomerID;



---------------------------------------------------------
-- Get Card Type
---------------------------------------------------------

SELECT TOP 1
@CardTypeID = CardTypeID
FROM Master.CardTypeMaster;



---------------------------------------------------------
-- Get Currency
---------------------------------------------------------

SELECT
@CurrencyID = CurrencyID
FROM Master.CurrencyMaster
WHERE CurrencyCode='EUR';



---------------------------------------------------------
-- CARD
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
'4000000000000001',
@AccountID,
@CustomerID,
@CardTypeID,
'VISA',
'Jean Martin',
GETDATE(),
DATEADD(YEAR,5,GETDATE()),
'ACTIVE',
1,
1,
1,
1,
SYSUTCDATETIME()
);



SET @CardID = SCOPE_IDENTITY();



---------------------------------------------------------
-- CARD LIMIT
---------------------------------------------------------

INSERT INTO Card.CardLimit
(
CardID,
DailyATMWithdrawalLimit,
DailyPOSLimit,
DailyOnlineLimit,
ContactlessLimit,
CurrencyID,
EffectiveFrom,
CreatedDate
)

VALUES
(
@CardID,
2000,
5000,
10000,
100,
@CurrencyID,
GETDATE(),
SYSUTCDATETIME()
);



---------------------------------------------------------
-- CARD AUTHORIZATION
---------------------------------------------------------

INSERT INTO Card.CardAuthorization
(
CardID,
AuthorizationCode,
MerchantName,
AuthorizationAmount,
CurrencyID,
AuthorizationStatus,
AuthorizationDate,
ExpiryDate,
CreatedDate
)

VALUES
(
@CardID,
'AUTH100001',
'Carrefour Luxembourg',
120,
@CurrencyID,
'APPROVED',
SYSUTCDATETIME(),
DATEADD(MINUTE,10,SYSUTCDATETIME()),
SYSUTCDATETIME()
);



---------------------------------------------------------
-- CARD PIN HISTORY
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
'Customer',
'ATM',
SYSUTCDATETIME()
);



---------------------------------------------------------
-- CARD TRANSACTION
---------------------------------------------------------

INSERT INTO Card.CardTransaction
(
CardID,
TransactionID,
MerchantName,
MerchantCountryID,
MerchantCategoryCode,
TransactionAmount,
CurrencyID,
TransactionDate,
AuthorizationCode,
CardEntryMode,
TransactionStatus,
CreatedDate
)

VALUES
(
@CardID,
NULL,
'Carrefour Luxembourg',
5,
'GROCERY',
120,
@CurrencyID,
SYSUTCDATETIME(),
'AUTH100001',
'CONTACTLESS',
'COMPLETED',
SYSUTCDATETIME()
);



---------------------------------------------------------
-- CARD AUDIT
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
'ACTIVE',
'Rakesh',
SYSUTCDATETIME(),
'SQL Server'
);



COMMIT TRANSACTION;


SELECT
'Card Test Data Loaded Successfully' AS Message,
@CardID AS CardID;


END TRY


BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK TRANSACTION;

THROW;

END CATCH;

GO
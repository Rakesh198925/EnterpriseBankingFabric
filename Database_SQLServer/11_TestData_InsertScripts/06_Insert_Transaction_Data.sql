/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Transaction Test Data
Script     : 06_Insert_Transaction_Data.sql
Author     : Rakesh Soma
Purpose    : Insert Transaction domain sample data
******************************************************************************/

USE BankingERP;
GO

SET NOCOUNT ON;

BEGIN TRY

BEGIN TRANSACTION;


DECLARE
@AccountID INT,
@CustomerID INT,
@CurrencyID INT,
@TransactionTypeID INT,
@TransactionID BIGINT,
@BeneficiaryID INT;


---------------------------------------------------------
-- Get Account
---------------------------------------------------------

SELECT TOP 1
@AccountID = AccountID,
@CustomerID = CustomerID
FROM Account.Account;



---------------------------------------------------------
-- Currency
---------------------------------------------------------

SELECT 
@CurrencyID = CurrencyID
FROM Master.CurrencyMaster
WHERE CurrencyCode='EUR';



---------------------------------------------------------
-- Transaction Type
---------------------------------------------------------

SELECT TOP 1
@TransactionTypeID = TransactionTypeID
FROM Master.TransactionTypeMaster;



---------------------------------------------------------
-- Exchange Rate
---------------------------------------------------------

INSERT INTO Transactions.ExchangeRate
(
FromCurrencyID,
ToCurrencyID,
ExchangeRate,
EffectiveDate,
CreatedDate
)

VALUES
(
@CurrencyID,
@CurrencyID,
1.000000,
GETDATE(),
SYSUTCDATETIME()
);



---------------------------------------------------------
-- BENEFICIARY
---------------------------------------------------------

INSERT INTO Transactions.Beneficiary
(
CustomerID,
BeneficiaryName,
IBAN,
BIC,
BankName,
BankCountryID,
BeneficiaryType,
IsTrusted,
IsActive,
CreatedDate
)

VALUES
(
@CustomerID,
'BNP Paribas Luxembourg',
'LU280019400644750000',
'BNPAFRPP',
'BNP Paribas',
1,
'BANK',
1,
1,
SYSUTCDATETIME()
);


SET @BeneficiaryID = SCOPE_IDENTITY();



---------------------------------------------------------
-- TRANSACTION
---------------------------------------------------------

---------------------------------------------------------
-- TRANSACTION
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
'TXN100001',
@AccountID,
@TransactionTypeID,
SYSUTCDATETIME(),
GETDATE(),
250.00,
@CurrencyID,
'D',
'COMPLETED',
'ONLINE',
'Online Banking Payment',
SYSUTCDATETIME(),
'Rakesh'
);


SET @TransactionID = SCOPE_IDENTITY();

---------------------------------------------------------
-- TRANSACTION DETAIL
---------------------------------------------------------

INSERT INTO Transactions.TransactionDetail
(
TransactionID,
MerchantName,
MerchantCategoryCode,
PaymentReference,
EndToEndReference,
RemittanceInformation,
AuthorizationCode,
SettlementDate,
CreatedDate
)

VALUES
(
@TransactionID,
'Amazon Europe',
'ECOMMERCE',
'PAY100001',
'E2E100001',
'Online Purchase',
'AUTH100001',
GETDATE(),
SYSUTCDATETIME()
);



---------------------------------------------------------
-- TRANSACTION FEE
---------------------------------------------------------

INSERT INTO Transactions.TransactionFee
(
TransactionID,
FeeType,
FeeAmount,
CurrencyID,
CreatedDate
)

VALUES
(
@TransactionID,
'TRANSFER_FEE',
2.50,
@CurrencyID,
SYSUTCDATETIME()
);



---------------------------------------------------------
-- TRANSACTION AUDIT
---------------------------------------------------------

INSERT INTO Transactions.TransactionAudit
(
TransactionID,
AuditAction,
PreviousStatus,
CurrentStatus,
ChangedBy,
ChangedDate,
SourceSystem
)

VALUES
(
@TransactionID,
'STATUS_CHANGE',
'PENDING',
'COMPLETED',
'System',
SYSUTCDATETIME(),
'SQL Server'
);



---------------------------------------------------------
-- PAYMENT
---------------------------------------------------------

INSERT INTO Transactions.Payment
(
TransactionID,
BeneficiaryID,
PaymentMethod,
PaymentStatus,
ExecutionDate,
SettlementDate,
ProcessingReference,
CreatedDate
)

VALUES
(
@TransactionID,
@BeneficiaryID,
'BANK_TRANSFER',
'COMPLETED',
SYSUTCDATETIME(),
SYSUTCDATETIME(),
'PROC100001',
SYSUTCDATETIME()
);



---------------------------------------------------------
-- STANDING INSTRUCTION
---------------------------------------------------------

INSERT INTO Transactions.StandingInstruction
(
AccountID,
BeneficiaryID,
Amount,
Frequency,
NextExecutionDate,
EndDate,
Status,
CreatedDate
)

VALUES
(
@AccountID,
@BeneficiaryID,
100,
'MONTHLY',
DATEADD(MONTH,1,GETDATE()),
DATEADD(YEAR,1,GETDATE()),
'ACTIVE',
SYSUTCDATETIME()
);



---------------------------------------------------------
-- DIRECT DEBIT
---------------------------------------------------------

INSERT INTO Transactions.DirectDebit
(
AccountID,
CreditorName,
CreditorIdentifier,
MandateReference,
CollectionFrequency,
Amount,
Status,
CreatedDate
)

VALUES
(
@AccountID,
'Luxembourg Energy Company',
'LUXENERGY001',
'MANDATE100001',
'MONTHLY',
75,
'ACTIVE',
SYSUTCDATETIME()
);



COMMIT TRANSACTION;


SELECT
'Transaction Test Data Loaded Successfully' AS Message,
@TransactionID AS TransactionID;



END TRY


BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK TRANSACTION;

THROW;

END CATCH;

GO
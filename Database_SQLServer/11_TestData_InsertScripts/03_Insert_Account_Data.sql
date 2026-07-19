/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Account Test Data
Script     : 03_Insert_Account_Data.sql
Author     : Rakesh Soma
Purpose    : Insert Account domain sample data
******************************************************************************/

USE BankingERP;
GO

SET NOCOUNT ON;

BEGIN TRY

BEGIN TRANSACTION;


DECLARE 
@CustomerID INT,
@BranchID INT,
@AccountTypeID INT,
@CurrencyID INT,
@AccountID INT;


---------------------------------------------------------
-- Get Customer
---------------------------------------------------------

SELECT TOP 1
@CustomerID = CustomerID
FROM Customer.Customer
WHERE CustomerNumber='CUST100001';



---------------------------------------------------------
-- Get Branch
---------------------------------------------------------

SELECT TOP 1
@BranchID = BranchID
FROM Master.BranchMaster;



---------------------------------------------------------
-- Get Account Type
---------------------------------------------------------

SELECT TOP 1
@AccountTypeID = AccountTypeID
FROM Master.AccountTypeMaster;



---------------------------------------------------------
-- Get EUR Currency
---------------------------------------------------------

SELECT 
@CurrencyID = CurrencyID
FROM Master.CurrencyMaster
WHERE CurrencyCode='EUR';



---------------------------------------------------------
-- ACCOUNT
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
'ACC100001',
'LU280019400644750000',
'Jean Martin Current Account',
@CustomerID,
@BranchID,
@AccountTypeID,
@CurrencyID,
GETDATE(),
'ACTIVE',
15000,
15000,
5000,
0,
1,
SYSUTCDATETIME(),
'Rakesh'
);



SET @AccountID = SCOPE_IDENTITY();



---------------------------------------------------------
-- ACCOUNT HOLDER
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
GETDATE(),
1,
1,
SYSUTCDATETIME(),
'Rakesh'
);



---------------------------------------------------------
-- ACCOUNT BALANCE
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
10000,
7000,
2000,
15000,
15000,
15000,
SYSUTCDATETIME()
);



---------------------------------------------------------
-- ACCOUNT INTEREST RATE
---------------------------------------------------------

INSERT INTO Account.AccountInterestRate
(
AccountID,
InterestRate,
RateType,
EffectiveFrom,
CreatedDate
)

VALUES
(
@AccountID,
1.25,
'SAVINGS',
GETDATE(),
SYSUTCDATETIME()
);



---------------------------------------------------------
-- ACCOUNT TRANSACTION LIMIT
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
2000,
5000,
10000,
5000,
'EUR',
GETDATE(),
SYSUTCDATETIME()
);



---------------------------------------------------------
-- ACCOUNT STATUS HISTORY
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
'NEW',
'ACTIVE',
'Account Opened',
SYSUTCDATETIME(),
'Rakesh',
SYSUTCDATETIME()
);



---------------------------------------------------------
-- ACCOUNT AUDIT
---------------------------------------------------------

INSERT INTO Account.AccountAudit
(
AccountID,
AuditAction,
ChangedColumn,
NewValue,
ChangedBy,
ChangedDate,
SourceSystem
)

VALUES
(
@AccountID,
'INSERT',
'AccountStatus',
'ACTIVE',
'Rakesh',
SYSUTCDATETIME(),
'SQL Server'
);



COMMIT TRANSACTION;


SELECT
'Account Test Data Loaded Successfully' AS Message,
@AccountID AS AccountID;



END TRY


BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK TRANSACTION;

THROW;

END CATCH;

GO
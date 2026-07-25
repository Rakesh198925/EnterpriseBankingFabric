/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Loan Test Data
Script     : 04_Insert_Loan_Data.sql
Author     : Rakesh Soma
Purpose    : Insert Loan domain sample data
******************************************************************************/

USE BankingERP;
GO

SET NOCOUNT ON;

BEGIN TRY

BEGIN TRANSACTION;


DECLARE @CustomerID INT;
DECLARE @AccountID INT;
DECLARE @LoanTypeID INT;
DECLARE @CurrencyID INT;


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
-- Get Loan Type
---------------------------------------------------------

SELECT TOP 1
@LoanTypeID = LoanTypeID
FROM Master.LoanTypeMaster
WHERE LoanTypeCode IN ('HOME','HL')
ORDER BY LoanTypeID;



---------------------------------------------------------
-- Get EUR Currency
---------------------------------------------------------

SELECT 
@CurrencyID = CurrencyID
FROM Master.CurrencyMaster
WHERE CurrencyCode='EUR';



---------------------------------------------------------
-- LOAN APPLICATION
---------------------------------------------------------

INSERT INTO Loan.LoanApplication
(
CustomerID,
LoanTypeID,
RequestedAmount,
RequestedTermMonths,
RequestedInterestRate,
ApplicationDate,
ApplicationStatus,
DecisionDate,
DecisionBy,
CreatedDate
)

VALUES
(
@CustomerID,
@LoanTypeID,
250000,
240,
3.75,
GETDATE(),
'APPROVED',
GETDATE(),
'Credit Manager',
SYSUTCDATETIME()
);



DECLARE @LoanApplicationID INT;

SET @LoanApplicationID = SCOPE_IDENTITY();



---------------------------------------------------------
-- LOAN
---------------------------------------------------------

INSERT INTO Loan.Loan
(
LoanNumber,
CustomerID,
AccountID,
LoanTypeID,
CurrencyID,
PrincipalAmount,
OutstandingAmount,
InterestRate,
LoanTermMonths,
StartDate,
MaturityDate,
LoanStatus,
CreatedDate,
CreatedBy
)

VALUES
(
'LN100001',
@CustomerID,
@AccountID,
@LoanTypeID,
@CurrencyID,
250000,
250000,
3.75,
240,
GETDATE(),
DATEADD(MONTH,240,GETDATE()),
'ACTIVE',
SYSUTCDATETIME(),
'Rakesh'
);



DECLARE @LoanID INT;

SET @LoanID = SCOPE_IDENTITY();



---------------------------------------------------------
-- REPAYMENT SCHEDULE
---------------------------------------------------------

INSERT INTO Loan.LoanRepaymentSchedule
(
LoanID,
InstallmentNumber,
DueDate,
PrincipalAmount,
InterestAmount,
TotalAmount,
OutstandingBalance,
PaymentStatus,
CreatedDate
)

VALUES

(
@LoanID,
1,
DATEADD(MONTH,1,GETDATE()),
800,
780,
1580,
248420,
'PENDING',
SYSUTCDATETIME()
),

(
@LoanID,
2,
DATEADD(MONTH,2,GETDATE()),
820,
760,
1580,
246840,
'PENDING',
SYSUTCDATETIME()
);



---------------------------------------------------------
-- LOAN PAYMENT
---------------------------------------------------------

INSERT INTO Loan.LoanPayment
(
LoanID,
AccountID,
PaymentDate,
PaymentAmount,
PaymentMethod,
PaymentStatus,
CreatedDate
)

VALUES
(
@LoanID,
@AccountID,
SYSUTCDATETIME(),
1580,
'BANK_TRANSFER',
'COMPLETED',
SYSUTCDATETIME()
);



---------------------------------------------------------
-- LOAN STATUS HISTORY
---------------------------------------------------------

INSERT INTO Loan.LoanStatusHistory
(
LoanID,
PreviousStatus,
CurrentStatus,
StatusReason,
EffectiveFrom,
ChangedBy,
CreatedDate
)

VALUES
(
@LoanID,
'PENDING',
'ACTIVE',
'Loan Approved and Disbursed',
SYSUTCDATETIME(),
'Credit Manager',
SYSUTCDATETIME()
);



---------------------------------------------------------
-- COLLATERAL
---------------------------------------------------------

INSERT INTO Loan.Collateral
(
LoanID,
CollateralType,
Description,
EstimatedValue,
ValuationDate,
ValuationCompany,
CountryID,
CreatedDate
)

SELECT

@LoanID,
'PROPERTY',
'Residential Property',
350000,
GETDATE(),
'European Valuation Services',
CountryID,
SYSUTCDATETIME()

FROM Master.CountryMaster
WHERE CountryCode='LU';



---------------------------------------------------------
-- LOAN AUDIT
---------------------------------------------------------

INSERT INTO Loan.LoanAudit
(
LoanID,
AuditAction,
ChangedColumn,
NewValue,
ChangedBy,
ChangedDate,
SourceSystem
)

VALUES
(
@LoanID,
'INSERT',
'LoanStatus',
'ACTIVE',
'Rakesh',
SYSUTCDATETIME(),
'SQL Server'
);



COMMIT TRANSACTION;


SELECT 
'Loan Test Data Loaded Successfully' AS Message,
@LoanID AS LoanID;



END TRY


BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK TRANSACTION;

THROW;

END CATCH;

GO
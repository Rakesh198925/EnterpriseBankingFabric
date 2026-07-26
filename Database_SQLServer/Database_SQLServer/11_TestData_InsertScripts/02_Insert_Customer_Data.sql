/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer Test Data
Script     : 02_Insert_Customer_Data.sql
Author     : Rakesh Soma
Purpose    : Insert customer sample data for testing
******************************************************************************/

USE BankingERP;
GO

SET NOCOUNT ON;

BEGIN TRANSACTION;

BEGIN TRY


---------------------------------------------------------
-- CUSTOMER INSERT
---------------------------------------------------------

DECLARE @RetailCustomerType INT;
DECLARE @HighRisk INT;
DECLARE @MediumRisk INT;
DECLARE @LowRisk INT;

DECLARE @ITOccupation INT;
DECLARE @BusinessOccupation INT;


SELECT @RetailCustomerType = CustomerTypeID
FROM Master.CustomerTypeMaster
WHERE CustomerTypeCode='RET';


SELECT @LowRisk = RiskCategoryID
FROM Master.RiskCategoryMaster
WHERE RiskCode='LOW';


SELECT @MediumRisk = RiskCategoryID
FROM Master.RiskCategoryMaster
WHERE RiskCode='MED';


SELECT @HighRisk = RiskCategoryID
FROM Master.RiskCategoryMaster
WHERE RiskCode='HIGH';


SELECT @ITOccupation = OccupationID
FROM Master.OccupationMaster
WHERE OccupationCode='IT';


SELECT @BusinessOccupation = OccupationID
FROM Master.OccupationMaster
WHERE OccupationCode='BUS';



---------------------------------------------------------
-- CUSTOMER
---------------------------------------------------------

INSERT INTO Customer.Customer
(
CustomerNumber,
FirstName,
MiddleName,
LastName,
DateOfBirth,
Gender,
MaritalStatus,
CustomerTypeID,
RiskCategoryID,
OccupationID,
BranchID,
NationalityCountryID,
EmailAddress,
MobileNumber,
TaxIdentificationNumber,
CustomerStatus,
KYCStatus,
IsActive,
CreatedDate,
CreatedBy,
CountryID,
NationalIdentificationNumber
)

VALUES

(
'CUST100001',
'Jean',
NULL,
'Martin',
'1985-05-12',
'M',
'Married',
@RetailCustomerType,
@LowRisk,
@ITOccupation,
1,
1,
'jean.martin@email.com',
'+352621111111',
'LU123456',
'ACTIVE',
'VERIFIED',
1,
SYSUTCDATETIME(),
'Rakesh',
1,
'LU998877'
),


(
'CUST100002',
'Anna',
NULL,
'Schmidt',
'1990-08-21',
'F',
'Single',
@RetailCustomerType,
@MediumRisk,
@BusinessOccupation,
1,
2,
'anna.schmidt@email.com',
'+491511234567',
'DE778899',
'ACTIVE',
'VERIFIED',
1,
SYSUTCDATETIME(),
'Rakesh',
2,
'DE445566'
),


(
'CUST100003',
'Pierre',
NULL,
'Dubois',
'1978-03-10',
'M',
'Married',
@RetailCustomerType,
@HighRisk,
@BusinessOccupation,
1,
3,
'pierre.dubois@email.com',
'+33161234567',
'FR556677',
'ACTIVE',
'PENDING',
1,
SYSUTCDATETIME(),
'Rakesh',
3,
'FR998877'
);


---------------------------------------------------------
-- CUSTOMER ADDRESS
---------------------------------------------------------

INSERT INTO Customer.CustomerAddress
(
CustomerID,
AddressType,
AddressLine1,
City,
StateProvince,
PostalCode,
CountryID,
IsPrimary,
IsActive,
CreatedBy
)

SELECT
CustomerID,
'HOME',
CASE CustomerNumber
WHEN 'CUST100001' THEN '10 Luxembourg Street'
WHEN 'CUST100002' THEN '20 Berlin Avenue'
WHEN 'CUST100003' THEN '30 Paris Road'
END,

CASE CustomerNumber
WHEN 'CUST100001' THEN 'Luxembourg'
WHEN 'CUST100002' THEN 'Berlin'
WHEN 'CUST100003' THEN 'Paris'
END,

'EU',
'1000',
CountryID,
1,
1,
'Rakesh'

FROM Customer.Customer
WHERE CustomerNumber IN
(
'CUST100001',
'CUST100002',
'CUST100003'
);



---------------------------------------------------------
-- CUSTOMER CONTACT
---------------------------------------------------------

INSERT INTO Customer.CustomerContact
(
CustomerID,
ContactType,
ContactNumber,
EmailAddress,
IsPrimary,
IsActive,
CreatedBy
)

SELECT
CustomerID,
'MOBILE',
MobileNumber,
EmailAddress,
1,
1,
'Rakesh'

FROM Customer.Customer
WHERE CustomerNumber IN
(
'CUST100001',
'CUST100002',
'CUST100003'
);



---------------------------------------------------------
-- CUSTOMER EMPLOYMENT
---------------------------------------------------------

INSERT INTO Customer.CustomerEmployment
(
CustomerID,
EmploymentStatus,
EmployerName,
JobTitle,
Industry,
EmploymentStartDate,
AnnualIncome,
IncomeCurrencyCode,
SourceOfFunds,
SourceOfWealth,
IsActive,
CreatedBy
)

SELECT
CustomerID,
'EMPLOYED',
'European Banking Group',
'Data Analyst',
'Banking',
'2020-01-01',
75000,
'EUR',
'Salary',
'Employment',
1,
'Rakesh'

FROM Customer.Customer
WHERE CustomerNumber='CUST100001';



---------------------------------------------------------
-- CUSTOMER KYC
---------------------------------------------------------

INSERT INTO Customer.CustomerKYC
(
CustomerID,
KYCReferenceNumber,
IdentificationType,
IdentificationNumber,
IssuingCountryID,
FATCAStatus,
CRSStatus,
PEPIndicator,
SanctionsScreeningStatus,
AMLRiskRating,
KYCStatus,
VerificationDate,
VerifiedBy,
CreatedBy
)

SELECT
CustomerID,
'KYC100001',
'PASSPORT',
'PASS123456',
NationalityCountryID,
'CLEAR',
'CLEAR',
0,
'CLEAR',
'LOW',
'APPROVED',
CAST(GETDATE() AS DATE),
'Compliance Team',
'Rakesh'

FROM Customer.Customer
WHERE CustomerNumber='CUST100001';



---------------------------------------------------------
-- CUSTOMER CONSENT
---------------------------------------------------------

INSERT INTO Customer.CustomerConsent
(
CustomerID,
ConsentType,
ConsentStatus,
ConsentDate,
ConsentSource,
Remarks,
CreatedBy
)

SELECT
CustomerID,
'DATA_PROCESSING',
1,
SYSUTCDATETIME(),
'ONLINE',
'GDPR Consent',
'Rakesh'

FROM Customer.Customer
WHERE CustomerNumber IN
(
'CUST100001',
'CUST100002',
'CUST100003'
);



---------------------------------------------------------
-- CUSTOMER AUDIT
---------------------------------------------------------

INSERT INTO Customer.CustomerAudit
(
CustomerID,
AuditAction,
ChangedColumn,
NewValue,
ChangedBy,
SourceSystem
)

SELECT
CustomerID,
'INSERT',
'Customer',
CustomerNumber,
'Rakesh',
'SQL Server'
FROM Customer.Customer
WHERE CustomerNumber IN
(
'CUST100001',
'CUST100002',
'CUST100003'
);



COMMIT TRANSACTION;


SELECT 
'Customer Test Data Loaded Successfully' AS Message;


END TRY


BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK TRANSACTION;

THROW;

END CATCH;

GO
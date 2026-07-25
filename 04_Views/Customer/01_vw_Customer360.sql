/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer Analytics
View       : Customer.vw_Customer360
Author     : Rakesh Soma

Purpose:
    Customer 360 view for Fabric Gold Layer
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER VIEW Customer.vw_Customer360
AS

SELECT

C.CustomerID,
C.CustomerNumber,

C.FirstName,
C.MiddleName,
C.LastName,

C.DateOfBirth,
C.Gender,
C.MaritalStatus,

CT.CustomerTypeName,

RC.RiskName,

O.OccupationName,

C.EmailAddress,
C.MobileNumber,

C.CustomerStatus,
C.KYCStatus,


-- Address

CA.AddressType,
CA.AddressLine1,
CA.City,
CA.StateProvince,
CA.PostalCode,


-- Contact

CC.ContactType,
CC.ContactNumber,


-- Employment

CE.EmploymentStatus,
CE.EmployerName,
CE.JobTitle,
CE.Industry,
CE.AnnualIncome,


-- KYC

KYC.KYCReferenceNumber,
KYC.IdentificationType,
KYC.KYCStatus AS VerificationStatus,
KYC.AMLRiskRating,
KYC.PEPIndicator,


C.IsActive,
C.CreatedDate,
C.CreatedBy


FROM Customer.Customer C


LEFT JOIN Master.CustomerTypeMaster CT
ON C.CustomerTypeID = CT.CustomerTypeID


LEFT JOIN Master.RiskCategoryMaster RC
ON C.RiskCategoryID = RC.RiskCategoryID


LEFT JOIN Master.OccupationMaster O
ON C.OccupationID = O.OccupationID


LEFT JOIN Customer.CustomerAddress CA
ON C.CustomerID = CA.CustomerID
AND CA.IsPrimary = 1


LEFT JOIN Customer.CustomerContact CC
ON C.CustomerID = CC.CustomerID
AND CC.IsPrimary = 1


LEFT JOIN Customer.CustomerEmployment CE
ON C.CustomerID = CE.CustomerID
AND CE.IsActive = 1


LEFT JOIN Customer.CustomerKYC KYC
ON C.CustomerID = KYC.CustomerID
AND KYC.IsActive = 1;


GO
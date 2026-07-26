/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer Compliance
View       : Customer.vw_CustomerKYCStatus
Author     : Rakesh Soma
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER VIEW Customer.vw_CustomerKYCStatus
AS


SELECT

C.CustomerID,

C.CustomerNumber,

C.FirstName + ' ' + C.LastName AS CustomerName,


K.KYCReferenceNumber,

K.IdentificationType,

K.IdentificationNumber,

K.KYCStatus,

K.AMLRiskRating,

K.PEPIndicator,

K.SanctionsScreeningStatus,

K.VerificationDate,

K.ReviewDueDate,


CASE

WHEN K.ReviewDueDate < CAST(GETDATE() AS DATE)

THEN 'KYC Review Required'

ELSE 'Valid'

END AS KYCReviewStatus


FROM Customer.Customer C


INNER JOIN Customer.CustomerKYC K

ON C.CustomerID = K.CustomerID;


GO
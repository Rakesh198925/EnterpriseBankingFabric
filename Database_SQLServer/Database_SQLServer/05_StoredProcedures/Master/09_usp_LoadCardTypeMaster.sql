/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Master Data
Procedure  : Master.usp_LoadCardTypeMaster
Author     : Rakesh Soma
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER PROCEDURE Master.usp_LoadCardTypeMaster
AS
BEGIN

SET NOCOUNT ON;


MERGE Master.CardTypeMaster AS TARGET


USING
(
VALUES

('DEBIT','Debit Card','VISA',0,5,'Standard debit card'),

('CREDIT','Credit Card','MASTERCARD',5000,50,'Credit card'),

('PREMIUM','Premium Card','VISA',25000,150,'Premium customer card'),

('BUSINESS','Business Card','MASTERCARD',50000,200,'Corporate card')


)

AS SOURCE
(
CardTypeCode,
CardTypeName,
CardNetwork,
CreditLimit,
AnnualFee,
Description
)


ON TARGET.CardTypeCode = SOURCE.CardTypeCode


WHEN MATCHED THEN

UPDATE SET

CardTypeName = SOURCE.CardTypeName,
CardNetwork = SOURCE.CardNetwork,
CreditLimit = SOURCE.CreditLimit,
AnnualFee = SOURCE.AnnualFee,
Description = SOURCE.Description,
IsActive = 1,
ModifiedDate = SYSUTCDATETIME(),
ModifiedBy = SUSER_SNAME()


WHEN NOT MATCHED THEN

INSERT
(
CardTypeCode,
CardTypeName,
CardNetwork,
CreditLimit,
AnnualFee,
Description,
IsActive,
CreatedDate,
CreatedBy
)

VALUES
(
SOURCE.CardTypeCode,
SOURCE.CardTypeName,
SOURCE.CardNetwork,
SOURCE.CreditLimit,
SOURCE.AnnualFee,
SOURCE.Description,
1,
SYSUTCDATETIME(),
SUSER_SNAME()
);


SELECT 'Card Type Master Loaded Successfully' AS Message;

END;
GO
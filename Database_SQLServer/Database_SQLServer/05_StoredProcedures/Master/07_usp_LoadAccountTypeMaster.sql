/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Master Data
Procedure  : Master.usp_LoadAccountTypeMaster
Author     : Rakesh Soma
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Master.usp_LoadAccountTypeMaster
AS
BEGIN

SET NOCOUNT ON;


MERGE Master.AccountTypeMaster AS TARGET

USING
(
VALUES

('SAV','Savings Account',0,2.50,'Personal savings account'),

('CUR','Current Account',0,0,'Business current account'),

('SAL','Salary Account',0,1.50,'Salary banking account'),

('PRE','Premium Account',1000,3.00,'Premium customer account'),

('NRE','NRE Account',5000,2.00,'Non resident external account')

)

AS SOURCE
(
AccountTypeCode,
AccountTypeName,
MinimumBalance,
InterestRate,
Description
)


ON TARGET.AccountTypeCode = SOURCE.AccountTypeCode


WHEN MATCHED THEN

UPDATE SET

AccountTypeName = SOURCE.AccountTypeName,
MinimumBalance = SOURCE.MinimumBalance,
InterestRate = SOURCE.InterestRate,
Description = SOURCE.Description,
IsActive = 1,
ModifiedDate = SYSUTCDATETIME(),
ModifiedBy = SUSER_SNAME()


WHEN NOT MATCHED THEN

INSERT
(
AccountTypeCode,
AccountTypeName,
MinimumBalance,
InterestRate,
Description,
IsActive,
CreatedDate,
CreatedBy
)

VALUES
(
SOURCE.AccountTypeCode,
SOURCE.AccountTypeName,
SOURCE.MinimumBalance,
SOURCE.InterestRate,
SOURCE.Description,
1,
SYSUTCDATETIME(),
SUSER_SNAME()
);


SELECT 'Account Type Master Loaded Successfully' AS Message;

END;
GO
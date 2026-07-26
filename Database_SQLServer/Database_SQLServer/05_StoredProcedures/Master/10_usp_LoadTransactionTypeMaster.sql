/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Master Data
Procedure  : Master.usp_LoadTransactionTypeMaster
Author     : Rakesh Soma
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER PROCEDURE Master.usp_LoadTransactionTypeMaster
AS
BEGIN

SET NOCOUNT ON;


MERGE Master.TransactionTypeMaster AS TARGET


USING
(
VALUES

('DEP','Deposit','CASH',0,'Account deposit'),

('WD','Withdrawal','CASH',1,'Cash withdrawal'),

('TRF','Transfer','TRANSFER',1,'Account transfer'),

('PAY','Payment','PAYMENT',1,'Customer payment'),

('FEE','Fee','CHARGE',1,'Bank fee'),

('INT','Interest','INTEREST',0,'Interest credit')


)

AS SOURCE
(
TransactionTypeCode,
TransactionTypeName,
TransactionCategory,
IsDebit,
Description
)


ON TARGET.TransactionTypeCode = SOURCE.TransactionTypeCode


WHEN MATCHED THEN

UPDATE SET

TransactionTypeName = SOURCE.TransactionTypeName,
TransactionCategory = SOURCE.TransactionCategory,
IsDebit = SOURCE.IsDebit,
Description = SOURCE.Description,
IsActive = 1,
ModifiedDate = SYSUTCDATETIME(),
ModifiedBy = SUSER_SNAME()



WHEN NOT MATCHED THEN


INSERT
(
TransactionTypeCode,
TransactionTypeName,
TransactionCategory,
IsDebit,
Description,
IsActive,
CreatedDate,
CreatedBy
)

VALUES
(
SOURCE.TransactionTypeCode,
SOURCE.TransactionTypeName,
SOURCE.TransactionCategory,
SOURCE.IsDebit,
SOURCE.Description,
1,
SYSUTCDATETIME(),
SUSER_SNAME()
);


SELECT 'Transaction Type Master Loaded Successfully' AS Message;

END;
GO
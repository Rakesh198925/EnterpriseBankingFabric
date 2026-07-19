/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Master Data
Procedure  : Master.usp_LoadCurrencyMaster
Author     : Rakesh Soma
Purpose    : Load Currency Master Data
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER PROCEDURE Master.usp_LoadCurrencyMaster
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


BEGIN TRY


BEGIN TRANSACTION;


MERGE Master.CurrencyMaster AS TARGET


USING
(
VALUES

('EUR','Euro',2),
('USD','US Dollar',2),
('INR','Indian Rupee',2),
('GBP','British Pound',2),
('CHF','Swiss Franc',2)


)

AS SOURCE
(
CurrencyCode,
CurrencyName,
DecimalPlaces
)



ON TARGET.CurrencyCode = SOURCE.CurrencyCode



WHEN MATCHED THEN

UPDATE SET

TARGET.CurrencyName = SOURCE.CurrencyName,

TARGET.DecimalPlaces = SOURCE.DecimalPlaces,

TARGET.IsActive = 1



WHEN NOT MATCHED THEN


INSERT
(
CurrencyCode,
CurrencyName,
DecimalPlaces,
IsActive,
CreatedDate
)

VALUES
(
SOURCE.CurrencyCode,
SOURCE.CurrencyName,
SOURCE.DecimalPlaces,
1,
SYSUTCDATETIME()
);



COMMIT TRANSACTION;


SELECT 
'Currency Master Loaded Successfully' AS Message;


END TRY


BEGIN CATCH


IF @@TRANCOUNT > 0
ROLLBACK;


THROW;


END CATCH


END;
GO
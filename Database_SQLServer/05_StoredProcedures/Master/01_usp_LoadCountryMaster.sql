/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Master Data
Procedure  : Master.usp_LoadCountryMaster
Author     : Rakesh Soma
Purpose    : Load Country Master Data
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Master.usp_LoadCountryMaster
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


BEGIN TRY

BEGIN TRANSACTION;


MERGE Master.CountryMaster AS TARGET

USING
(
VALUES

('IN','India','IND','INR','Indian Country'),
('LU','Luxembourg','LUX','EUR','European Country'),
('DE','Germany','DEU','EUR','European Country'),
('FR','France','FRA','EUR','European Country'),
('BE','Belgium','BEL','EUR','European Country'),
('US','United States','USA','USD','United States')

)
AS SOURCE
(
CountryCode,
CountryName,
ISOCode3,
CurrencyCode,
Description
)


ON TARGET.CountryCode = SOURCE.CountryCode


WHEN MATCHED THEN

UPDATE SET

CountryName = SOURCE.CountryName,
ISOCode3 = SOURCE.ISOCode3,
CurrencyCode = SOURCE.CurrencyCode,
Description = SOURCE.Description,
ModifiedDate = SYSUTCDATETIME(),
ModifiedBy = SUSER_SNAME()


WHEN NOT MATCHED THEN

INSERT
(
CountryCode,
CountryName,
ISOCode3,
CurrencyCode,
Description,
IsActive,
CreatedDate,
CreatedBy
)

VALUES
(
SOURCE.CountryCode,
SOURCE.CountryName,
SOURCE.ISOCode3,
SOURCE.CurrencyCode,
SOURCE.Description,
1,
SYSUTCDATETIME(),
SUSER_SNAME()
);


COMMIT;


SELECT 'Country Master Loaded Successfully' AS Message;


END TRY


BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK;

THROW;

END CATCH

END;
GO
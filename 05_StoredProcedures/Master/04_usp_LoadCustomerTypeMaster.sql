/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Master Data
Procedure  : Master.usp_LoadCustomerTypeMaster
Author     : Rakesh Soma
Purpose    : Load Customer Type Master
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER PROCEDURE Master.usp_LoadCustomerTypeMaster
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


BEGIN TRY

BEGIN TRANSACTION;


MERGE Master.CustomerTypeMaster AS TARGET

USING
(
VALUES

('RET','Retail Customer','Individual banking customer'),
('COR','Corporate Customer','Large business customer'),
('SME','SME Customer','Small and medium enterprise'),
('HNI','High Net Worth Individual','Premium customer'),
('NRI','Non Resident Indian','International customer'),
('GOV','Government Customer','Government organization')

)

AS SOURCE
(
CustomerTypeCode,
CustomerTypeName,
Description
)


ON TARGET.CustomerTypeCode = SOURCE.CustomerTypeCode


WHEN MATCHED THEN

UPDATE SET

CustomerTypeName = SOURCE.CustomerTypeName,
Description = SOURCE.Description,
IsActive = 1,
ModifiedDate = SYSUTCDATETIME(),
ModifiedBy = SUSER_SNAME()



WHEN NOT MATCHED THEN


INSERT
(
CustomerTypeCode,
CustomerTypeName,
Description,
IsActive,
CreatedDate,
CreatedBy
)

VALUES
(
SOURCE.CustomerTypeCode,
SOURCE.CustomerTypeName,
SOURCE.Description,
1,
SYSUTCDATETIME(),
SUSER_SNAME()
);


COMMIT;


SELECT 'Customer Type Master Loaded Successfully' AS Message;


END TRY


BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK;

THROW;

END CATCH

END;
GO
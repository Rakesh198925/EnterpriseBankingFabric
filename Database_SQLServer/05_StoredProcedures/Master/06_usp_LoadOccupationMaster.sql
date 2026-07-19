/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Master Data
Procedure  : Master.usp_LoadOccupationMaster
Author     : Rakesh Soma
Purpose    : Load Occupation Master
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER PROCEDURE Master.usp_LoadOccupationMaster
AS
BEGIN

SET NOCOUNT ON;


MERGE Master.OccupationMaster AS TARGET


USING
(
VALUES

('EMP','Employee','Employment','Salaried employee'),

('BUS','Business Owner','Business','Business owner'),

('SE','Self Employed','Professional','Independent professional'),

('STU','Student','Education','Student'),

('RET','Retired','Retired','Retired person'),

('GOV','Government Employee','Government','Government sector employee')


)

AS SOURCE
(
OccupationCode,
OccupationName,
Industry,
Description
)



ON TARGET.OccupationCode = SOURCE.OccupationCode



WHEN MATCHED THEN


UPDATE SET

OccupationName = SOURCE.OccupationName,
Industry = SOURCE.Industry,
Description = SOURCE.Description,
IsActive = 1,
ModifiedDate = SYSUTCDATETIME(),
ModifiedBy = SUSER_SNAME()



WHEN NOT MATCHED THEN


INSERT
(
OccupationCode,
OccupationName,
Industry,
Description,
IsActive,
CreatedDate,
CreatedBy
)

VALUES
(
SOURCE.OccupationCode,
SOURCE.OccupationName,
SOURCE.Industry,
SOURCE.Description,
1,
SYSUTCDATETIME(),
SUSER_SNAME()
);



SELECT 'Occupation Master Loaded Successfully' AS Message;


END;
GO
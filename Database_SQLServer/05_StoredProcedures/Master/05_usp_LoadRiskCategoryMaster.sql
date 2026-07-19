/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Master Data
Procedure  : Master.usp_LoadRiskCategoryMaster
Author     : Rakesh Soma
Purpose    : Load Risk Category Master
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER PROCEDURE Master.usp_LoadRiskCategoryMaster
AS
BEGIN

SET NOCOUNT ON;


MERGE Master.RiskCategoryMaster AS TARGET


USING
(
VALUES

('LOW','Low Risk',1,'Low customer risk'),

('MED','Medium Risk',2,'Medium customer risk'),

('HIGH','High Risk',3,'High customer risk'),

('CRIT','Critical Risk',4,'Critical AML risk')


)

AS SOURCE
(
RiskCode,
RiskName,
RiskScore,
Description
)



ON TARGET.RiskCode = SOURCE.RiskCode



WHEN MATCHED THEN


UPDATE SET

RiskName = SOURCE.RiskName,
RiskScore = SOURCE.RiskScore,
Description = SOURCE.Description,
IsActive = 1,
ModifiedDate = SYSUTCDATETIME(),
ModifiedBy = SUSER_SNAME()



WHEN NOT MATCHED THEN


INSERT
(
RiskCode,
RiskName,
RiskScore,
Description,
IsActive,
CreatedDate,
CreatedBy
)

VALUES
(
SOURCE.RiskCode,
SOURCE.RiskName,
SOURCE.RiskScore,
SOURCE.Description,
1,
SYSUTCDATETIME(),
SUSER_SNAME()
);



SELECT 'Risk Category Master Loaded Successfully' AS Message;


END;
GO
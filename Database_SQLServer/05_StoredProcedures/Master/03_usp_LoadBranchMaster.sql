/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Master Data
Procedure  : Master.usp_LoadBranchMaster
Author     : Rakesh Soma
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER PROCEDURE Master.usp_LoadBranchMaster
AS
BEGIN


SET NOCOUNT ON;


MERGE Master.BranchMaster AS TARGET


USING
(
VALUES

('LUX001',
'Luxembourg Central Branch',
2,
'Luxembourg City',
'12 Banking Street',
'L-1000'),


('IND001',
'Hyderabad Branch',
1,
'Hyderabad',
'Financial District',
'500032'),


('DE001',
'Frankfurt Branch',
3,
'Frankfurt',
'Main Street',
'60311')


)

AS SOURCE
(
BranchCode,
BranchName,
CountryID,
City,
AddressLine1,
PostalCode
)


ON TARGET.BranchCode = SOURCE.BranchCode


WHEN MATCHED THEN

UPDATE SET

BranchName = SOURCE.BranchName,
City = SOURCE.City,
AddressLine1 = SOURCE.AddressLine1,
PostalCode = SOURCE.PostalCode,
ModifiedDate = SYSUTCDATETIME()


WHEN NOT MATCHED THEN


INSERT
(
BranchCode,
BranchName,
CountryID,
City,
AddressLine1,
PostalCode,
IsActive,
CreatedDate,
CreatedBy
)

VALUES
(
SOURCE.BranchCode,
SOURCE.BranchName,
SOURCE.CountryID,
SOURCE.City,
SOURCE.AddressLine1,
SOURCE.PostalCode,
1,
SYSUTCDATETIME(),
SUSER_SNAME()
);



SELECT 'Branch Master Loaded Successfully' AS Message;


END;
GO
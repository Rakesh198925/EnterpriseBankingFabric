/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Master Data
Procedure  : Master.usp_LoadLoanTypeMaster
Author     : Rakesh Soma
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER PROCEDURE Master.usp_LoadLoanTypeMaster
AS
BEGIN

SET NOCOUNT ON;


MERGE Master.LoanTypeMaster AS TARGET

USING
(
VALUES

('HOME','Home Loan',7.50,360,'Residential property loan'),

('AUTO','Auto Loan',8.50,84,'Vehicle finance loan'),

('PERSONAL','Personal Loan',12.00,60,'Personal finance loan'),

('BUSINESS','Business Loan',10.00,120,'Business funding loan'),

('EDU','Education Loan',6.50,180,'Student education loan')

)

AS SOURCE
(
LoanTypeCode,
LoanTypeName,
DefaultInterestRate,
MaximumTenureMonths,
Description
)


ON TARGET.LoanTypeCode = SOURCE.LoanTypeCode


WHEN MATCHED THEN

UPDATE SET

LoanTypeName = SOURCE.LoanTypeName,
DefaultInterestRate = SOURCE.DefaultInterestRate,
MaximumTenureMonths = SOURCE.MaximumTenureMonths,
Description = SOURCE.Description,
IsActive = 1,
ModifiedDate = SYSUTCDATETIME(),
ModifiedBy = SUSER_SNAME()


WHEN NOT MATCHED THEN

INSERT
(
LoanTypeCode,
LoanTypeName,
DefaultInterestRate,
MaximumTenureMonths,
Description,
IsActive,
CreatedDate,
CreatedBy
)

VALUES
(
SOURCE.LoanTypeCode,
SOURCE.LoanTypeName,
SOURCE.DefaultInterestRate,
SOURCE.MaximumTenureMonths,
SOURCE.Description,
1,
SYSUTCDATETIME(),
SUSER_SNAME()
);


SELECT 'Loan Type Master Loaded Successfully' AS Message;

END;
GO
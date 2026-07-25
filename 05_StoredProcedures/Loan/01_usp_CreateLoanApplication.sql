/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Loan
Procedure  : usp_CreateLoanApplication
Author     : Rakesh Soma
Purpose    : Create customer loan application
Technology : SQL Server 2019
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Loan.usp_CreateLoanApplication
(
      @CustomerID              INT
    , @LoanTypeID              INT
    , @RequestedAmount         DECIMAL(18,2)
    , @RequestedTermMonths     INT
    , @RequestedInterestRate   DECIMAL(5,2)
    , @CreatedBy               NVARCHAR(200)
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


BEGIN TRY

BEGIN TRANSACTION;


---------------------------------------------------------
-- Validate Customer
---------------------------------------------------------

IF NOT EXISTS
(
    SELECT 1
    FROM Customer.Customer
    WHERE CustomerID = @CustomerID
      AND IsActive = 1
)
BEGIN
    THROW 60001,'Invalid customer.',1;
END;



---------------------------------------------------------
-- Create Application
---------------------------------------------------------

INSERT INTO Loan.LoanApplication
(
    CustomerID,
    LoanTypeID,
    RequestedAmount,
    RequestedTermMonths,
    RequestedInterestRate,
    ApplicationDate,
    ApplicationStatus,
    CreatedDate
)
VALUES
(
    @CustomerID,
    @LoanTypeID,
    @RequestedAmount,
    @RequestedTermMonths,
    @RequestedInterestRate,
    CAST(GETDATE() AS DATE),
    'PENDING',
    SYSUTCDATETIME()
);



DECLARE @LoanApplicationID INT;

SET @LoanApplicationID = SCOPE_IDENTITY();



COMMIT TRANSACTION;


SELECT
    @LoanApplicationID AS LoanApplicationID,
    'Loan application created successfully' AS Message;


END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK;

THROW;

END CATCH

END;
GO
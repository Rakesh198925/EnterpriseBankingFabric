/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer
Procedure  : Customer.usp_UpdateCustomer
Author     : Rakesh Soma
Purpose    : Update Customer Information
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Customer.usp_UpdateCustomer
(
      @CustomerID                     INT
    , @FirstName                      NVARCHAR(100)
    , @MiddleName                     NVARCHAR(100)=NULL
    , @LastName                       NVARCHAR(100)
    , @MaritalStatus                  VARCHAR(20)=NULL
    , @RiskCategoryID                 INT
    , @OccupationID                   INT=NULL
    , @BranchID                       INT
    , @NationalityCountryID           INT=NULL
    , @CountryID                      INT=NULL
    , @EmailAddress                   NVARCHAR(200)=NULL
    , @MobileNumber                   VARCHAR(20)=NULL
    , @NationalIdentificationNumber   VARCHAR(50)=NULL
    , @TaxIdentificationNumber        VARCHAR(50)=NULL
    , @ModifiedBy                     NVARCHAR(100)
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY

    BEGIN TRANSACTION;

    -----------------------------------------------------
    -- Customer Validation
    -----------------------------------------------------

    IF NOT EXISTS
    (
        SELECT 1
        FROM Customer.Customer
        WHERE CustomerID=@CustomerID
    )
    BEGIN
        THROW 50010,'Customer not found.',1;
    END;

    -----------------------------------------------------
    -- Master Validation
    -----------------------------------------------------

    IF NOT EXISTS
    (
        SELECT 1
        FROM Master.RiskCategoryMaster
        WHERE RiskCategoryID=@RiskCategoryID
    )
        THROW 50011,'Invalid Risk Category.',1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM Master.BranchMaster
        WHERE BranchID=@BranchID
    )
        THROW 50012,'Invalid Branch.',1;

    IF @OccupationID IS NOT NULL
    AND NOT EXISTS
    (
        SELECT 1
        FROM Master.OccupationMaster
        WHERE OccupationID=@OccupationID
    )
        THROW 50013,'Invalid Occupation.',1;

    -----------------------------------------------------
    -- Update
    -----------------------------------------------------

    UPDATE Customer.Customer
       SET FirstName                    = @FirstName,
           MiddleName                   = @MiddleName,
           LastName                     = @LastName,
           MaritalStatus                = @MaritalStatus,
           RiskCategoryID               = @RiskCategoryID,
           OccupationID                 = @OccupationID,
           BranchID                     = @BranchID,
           NationalityCountryID         = @NationalityCountryID,
           CountryID                    = @CountryID,
           EmailAddress                 = @EmailAddress,
           MobileNumber                 = @MobileNumber,
           NationalIdentificationNumber = @NationalIdentificationNumber,
           TaxIdentificationNumber      = @TaxIdentificationNumber,
           ModifiedDate                 = SYSUTCDATETIME(),
           ModifiedBy                   = @ModifiedBy
     WHERE CustomerID=@CustomerID;

    COMMIT TRANSACTION;

    SELECT
        @CustomerID AS CustomerID,
        'Customer Updated Successfully' AS Message;

END TRY

BEGIN CATCH

    IF @@TRANCOUNT>0
        ROLLBACK TRANSACTION;

    THROW;

END CATCH

END;
GO
/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer
Procedure  : Customer.usp_CreateCustomerKYC
Author     : Rakesh Soma
Purpose    : Create Customer KYC Record (European Banking)
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Customer.usp_CreateCustomerKYC
(
      @CustomerID                    INT
    , @KYCReferenceNumber            VARCHAR(50)
    , @IdentificationType            VARCHAR(50)
    , @IdentificationNumber          VARCHAR(100)
    , @IssuingCountryID              INT
    , @IssueDate                     DATE = NULL
    , @ExpiryDate                    DATE = NULL
    , @TaxIdentificationNumber       VARCHAR(50)=NULL
    , @FATCAStatus                   VARCHAR(20)=NULL
    , @CRSStatus                     VARCHAR(20)=NULL
    , @PEPIndicator                  BIT=0
    , @SanctionsScreeningStatus      VARCHAR(30)
    , @AMLRiskRating                 VARCHAR(30)
    , @KYCStatus                     VARCHAR(30)
    , @VerificationDate              DATE=NULL
    , @VerifiedBy                    NVARCHAR(100)=NULL
    , @ReviewDueDate                 DATE=NULL
    , @CreatedBy                     NVARCHAR(100)
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY

    BEGIN TRANSACTION;

    ----------------------------------------------------
    -- Customer Validation
    ----------------------------------------------------

    IF NOT EXISTS
    (
        SELECT 1
        FROM Customer.Customer
        WHERE CustomerID=@CustomerID
    )
    BEGIN
        THROW 50101,'Customer does not exist.',1;
    END;

    ----------------------------------------------------
    -- Country Validation
    ----------------------------------------------------

    IF NOT EXISTS
    (
        SELECT 1
        FROM Master.CountryMaster
        WHERE CountryID=@IssuingCountryID
    )
    BEGIN
        THROW 50102,'Invalid Issuing Country.',1;
    END;

    ----------------------------------------------------
    -- Duplicate KYC Reference
    ----------------------------------------------------

    IF EXISTS
    (
        SELECT 1
        FROM Customer.CustomerKYC
        WHERE KYCReferenceNumber=@KYCReferenceNumber
    )
    BEGIN
        THROW 50103,'KYC Reference Number already exists.',1;
    END;

    ----------------------------------------------------
    -- Duplicate Identification Number
    ----------------------------------------------------

    IF EXISTS
    (
        SELECT 1
        FROM Customer.CustomerKYC
        WHERE IdentificationNumber=@IdentificationNumber
          AND IdentificationType=@IdentificationType
    )
    BEGIN
        THROW 50104,'Identification Number already exists.',1;
    END;

    ----------------------------------------------------
    -- Insert KYC
    ----------------------------------------------------

    INSERT INTO Customer.CustomerKYC
    (
        CustomerID,
        KYCReferenceNumber,
        IdentificationType,
        IdentificationNumber,
        IssuingCountryID,
        IssueDate,
        ExpiryDate,
        TaxIdentificationNumber,
        FATCAStatus,
        CRSStatus,
        PEPIndicator,
        SanctionsScreeningStatus,
        AMLRiskRating,
        KYCStatus,
        VerificationDate,
        VerifiedBy,
        ReviewDueDate,
        IsActive,
        CreatedDate,
        CreatedBy
    )
    VALUES
    (
        @CustomerID,
        @KYCReferenceNumber,
        @IdentificationType,
        @IdentificationNumber,
        @IssuingCountryID,
        @IssueDate,
        @ExpiryDate,
        @TaxIdentificationNumber,
        @FATCAStatus,
        @CRSStatus,
        @PEPIndicator,
        @SanctionsScreeningStatus,
        @AMLRiskRating,
        @KYCStatus,
        @VerificationDate,
        @VerifiedBy,
        @ReviewDueDate,
        1,
        SYSUTCDATETIME(),
        @CreatedBy
    );

    ----------------------------------------------------
    -- Update Customer KYC Status
    ----------------------------------------------------

    UPDATE Customer.Customer
       SET KYCStatus=@KYCStatus,
           ModifiedDate=SYSUTCDATETIME(),
           ModifiedBy=@CreatedBy
     WHERE CustomerID=@CustomerID;

    DECLARE @CustomerKYCID INT=SCOPE_IDENTITY();

    COMMIT TRANSACTION;

    SELECT
        @CustomerKYCID AS CustomerKYCID,
        'Customer KYC Created Successfully' AS Message;

END TRY

BEGIN CATCH

    IF @@TRANCOUNT>0
        ROLLBACK TRANSACTION;

    THROW;

END CATCH

END;
GO
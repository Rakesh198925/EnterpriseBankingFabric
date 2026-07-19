/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer
Procedure  : Customer.usp_CreateCustomer
Author     : Rakesh Soma
Purpose    : Create a new customer (European Banking)
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Customer.usp_CreateCustomer
(
      @CustomerNumber                 VARCHAR(20)
    , @FirstName                      NVARCHAR(100)
    , @MiddleName                     NVARCHAR(100) = NULL
    , @LastName                       NVARCHAR(100)
    , @DateOfBirth                    DATE
    , @Gender                         CHAR(1)
    , @MaritalStatus                  VARCHAR(20) = NULL
    , @CustomerTypeID                 INT
    , @RiskCategoryID                 INT
    , @OccupationID                   INT = NULL
    , @BranchID                       INT
    , @NationalityCountryID           INT = NULL
    , @CountryID                      INT = NULL
    , @EmailAddress                   NVARCHAR(200) = NULL
    , @MobileNumber                   VARCHAR(20) = NULL
    , @NationalIdentificationNumber   VARCHAR(50) = NULL
    , @TaxIdentificationNumber        VARCHAR(50) = NULL
    , @CreatedBy                      NVARCHAR(100) = NULL
)
AS
BEGIN

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        --------------------------------------------------------
        -- Duplicate Customer Number Validation
        --------------------------------------------------------

        IF EXISTS
        (
            SELECT 1
            FROM Customer.Customer
            WHERE CustomerNumber = @CustomerNumber
        )
        BEGIN
            THROW 50001, 'Customer Number already exists.', 1;
        END;

        --------------------------------------------------------
        -- Customer Type Validation
        --------------------------------------------------------

        IF NOT EXISTS
        (
            SELECT 1
            FROM Master.CustomerTypeMaster
            WHERE CustomerTypeID = @CustomerTypeID
        )
        BEGIN
            THROW 50002, 'Invalid Customer Type.', 1;
        END;

        --------------------------------------------------------
        -- Risk Category Validation
        --------------------------------------------------------

        IF NOT EXISTS
        (
            SELECT 1
            FROM Master.RiskCategoryMaster
            WHERE RiskCategoryID = @RiskCategoryID
        )
        BEGIN
            THROW 50003, 'Invalid Risk Category.', 1;
        END;

        --------------------------------------------------------
        -- Branch Validation
        --------------------------------------------------------

        IF NOT EXISTS
        (
            SELECT 1
            FROM Master.BranchMaster
            WHERE BranchID = @BranchID
        )
        BEGIN
            THROW 50004, 'Invalid Branch.', 1;
        END;

        --------------------------------------------------------
        -- Occupation Validation
        --------------------------------------------------------

        IF @OccupationID IS NOT NULL
        AND NOT EXISTS
        (
            SELECT 1
            FROM Master.OccupationMaster
            WHERE OccupationID = @OccupationID
        )
        BEGIN
            THROW 50005, 'Invalid Occupation.', 1;
        END;

        --------------------------------------------------------
        -- Insert Customer
        --------------------------------------------------------

        INSERT INTO Customer.Customer
        (
            CustomerNumber,
            FirstName,
            MiddleName,
            LastName,
            DateOfBirth,
            Gender,
            MaritalStatus,
            CustomerTypeID,
            RiskCategoryID,
            OccupationID,
            BranchID,
            NationalityCountryID,
            EmailAddress,
            MobileNumber,
            NationalIdentificationNumber,
            TaxIdentificationNumber,
            CustomerStatus,
            KYCStatus,
            IsActive,
            CreatedDate,
            CreatedBy,
            CountryID
        )
        VALUES
        (
            @CustomerNumber,
            @FirstName,
            @MiddleName,
            @LastName,
            @DateOfBirth,
            @Gender,
            @MaritalStatus,
            @CustomerTypeID,
            @RiskCategoryID,
            @OccupationID,
            @BranchID,
            @NationalityCountryID,
            @EmailAddress,
            @MobileNumber,
            @NationalIdentificationNumber,
            @TaxIdentificationNumber,
            'Active',
            'Pending',
            1,
            SYSUTCDATETIME(),
            ISNULL(@CreatedBy, SUSER_SNAME()),
            @CountryID
        );

        DECLARE @CustomerID INT = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SELECT
            @CustomerID AS CustomerID,
            @CustomerNumber AS CustomerNumber,
            'Customer Created Successfully' AS Message;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH

END;
GO
-----------------------************
IF COL_LENGTH('Customer.CustomerKYC', 'PANNumber') IS NOT NULL
BEGIN
    EXEC sp_rename
        'Customer.CustomerKYC.PANNumber',
        'NationalIdentificationNumber',
        'COLUMN';

    PRINT 'CustomerKYC updated.';
END
GO
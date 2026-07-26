/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer
Procedure  : Customer.usp_CreateCustomerEmployment
Author     : Rakesh Soma
Purpose    : Create Customer Employment Information
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Customer.usp_CreateCustomerEmployment
(
      @CustomerID                INT
    , @EmploymentStatus          VARCHAR(30)
    , @EmployerName              NVARCHAR(200)=NULL
    , @JobTitle                  NVARCHAR(100)=NULL
    , @Industry                  NVARCHAR(100)=NULL
    , @EmploymentStartDate       DATE=NULL
    , @AnnualIncome              DECIMAL(18,2)=NULL
    , @IncomeCurrencyCode        CHAR(3)=NULL
    , @SourceOfFunds             NVARCHAR(200)=NULL
    , @SourceOfWealth            NVARCHAR(200)=NULL
    , @TaxResidenceCountryID     INT=NULL
    , @CreatedBy                 NVARCHAR(100)
)
AS
BEGIN

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        ---------------------------------------------------
        -- Validate Customer
        ---------------------------------------------------

        IF NOT EXISTS
        (
            SELECT 1
            FROM Customer.Customer
            WHERE CustomerID=@CustomerID
        )
        BEGIN
            THROW 50121,'Customer does not exist.',1;
        END;

        ---------------------------------------------------
        -- Validate Country
        ---------------------------------------------------

        IF @TaxResidenceCountryID IS NOT NULL
        AND NOT EXISTS
        (
            SELECT 1
            FROM Master.CountryMaster
            WHERE CountryID=@TaxResidenceCountryID
        )
        BEGIN
            THROW 50122,'Invalid Tax Residence Country.',1;
        END;

        ---------------------------------------------------
        -- One Active Employment Record
        ---------------------------------------------------

        UPDATE Customer.CustomerEmployment
           SET IsActive = 0,
               ModifiedDate = SYSUTCDATETIME(),
               ModifiedBy = @CreatedBy
         WHERE CustomerID = @CustomerID
           AND IsActive = 1;

        ---------------------------------------------------
        -- Insert Employment
        ---------------------------------------------------

        INSERT INTO Customer.CustomerEmployment
        (
            CustomerID,
            EmploymentStatus,
            EmployerName,
            JobTitle,
            Industry,
            EmploymentStartDate,
            AnnualIncome,
            IncomeCurrencyCode,
            SourceOfFunds,
            SourceOfWealth,
            TaxResidenceCountryID,
            IsActive,
            CreatedDate,
            CreatedBy
        )
        VALUES
        (
            @CustomerID,
            @EmploymentStatus,
            @EmployerName,
            @JobTitle,
            @Industry,
            @EmploymentStartDate,
            @AnnualIncome,
            @IncomeCurrencyCode,
            @SourceOfFunds,
            @SourceOfWealth,
            @TaxResidenceCountryID,
            1,
            SYSUTCDATETIME(),
            @CreatedBy
        );

        DECLARE @CustomerEmploymentID INT = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SELECT
            @CustomerEmploymentID AS CustomerEmploymentID,
            'Customer Employment Created Successfully' AS Message;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH

END;
GO
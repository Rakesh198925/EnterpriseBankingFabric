/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer
Procedure  : Customer.usp_CreateCustomerConsent
Author     : Rakesh Soma
Purpose    : Create or Update Customer Consent
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Customer.usp_CreateCustomerConsent
(
      @CustomerID         INT
    , @ConsentType        VARCHAR(50)
    , @ConsentStatus      BIT
    , @ConsentDate        DATETIME2
    , @ExpiryDate         DATE = NULL
    , @ConsentSource      VARCHAR(50) = NULL
    , @Remarks            NVARCHAR(500) = NULL
    , @CreatedBy          NVARCHAR(100)
)
AS
BEGIN

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        -------------------------------------------------------
        -- Validate Customer
        -------------------------------------------------------

        IF NOT EXISTS
        (
            SELECT 1
            FROM Customer.Customer
            WHERE CustomerID = @CustomerID
        )
        BEGIN
            THROW 50131, 'Customer does not exist.', 1;
        END;

        -------------------------------------------------------
        -- Check Existing Consent
        -------------------------------------------------------

        IF EXISTS
        (
            SELECT 1
            FROM Customer.CustomerConsent
            WHERE CustomerID = @CustomerID
              AND ConsentType = @ConsentType
        )
        BEGIN

            UPDATE Customer.CustomerConsent
               SET ConsentStatus = @ConsentStatus,
                   ConsentDate = @ConsentDate,
                   ExpiryDate = @ExpiryDate,
                   ConsentSource = @ConsentSource,
                   Remarks = @Remarks,
                   ModifiedDate = SYSUTCDATETIME(),
                   ModifiedBy = @CreatedBy
             WHERE CustomerID = @CustomerID
               AND ConsentType = @ConsentType;

            COMMIT TRANSACTION;

            SELECT
                'Customer Consent Updated Successfully' AS Message;

            RETURN;

        END;

        -------------------------------------------------------
        -- Insert Consent
        -------------------------------------------------------

        INSERT INTO Customer.CustomerConsent
        (
            CustomerID,
            ConsentType,
            ConsentStatus,
            ConsentDate,
            ExpiryDate,
            ConsentSource,
            Remarks,
            CreatedDate,
            CreatedBy
        )
        VALUES
        (
            @CustomerID,
            @ConsentType,
            @ConsentStatus,
            @ConsentDate,
            @ExpiryDate,
            @ConsentSource,
            @Remarks,
            SYSUTCDATETIME(),
            @CreatedBy
        );

        DECLARE @CustomerConsentID INT = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SELECT
            @CustomerConsentID AS CustomerConsentID,
            'Customer Consent Created Successfully' AS Message;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH

END;
GO
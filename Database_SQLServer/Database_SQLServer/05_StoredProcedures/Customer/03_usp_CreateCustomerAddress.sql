/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer
Procedure  : Customer.usp_CreateCustomerAddress
Author     : Rakesh Soma
Purpose    : Create Customer Address
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Customer.usp_CreateCustomerAddress
(
      @CustomerID          INT
    , @AddressType         VARCHAR(30)
    , @AddressLine1        NVARCHAR(200)
    , @AddressLine2        NVARCHAR(200)=NULL
    , @City                NVARCHAR(100)
    , @StateProvince       NVARCHAR(100)
    , @PostalCode          NVARCHAR(20)
    , @CountryID           INT
    , @IsPrimary           BIT=1
    , @CreatedBy           NVARCHAR(100)
)
AS
BEGIN

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        ----------------------------------------------------
        -- Validate Customer
        ----------------------------------------------------

        IF NOT EXISTS
        (
            SELECT 1
            FROM Customer.Customer
            WHERE CustomerID=@CustomerID
        )
        BEGIN
            THROW 50021,'Customer does not exist.',1;
        END;

        ----------------------------------------------------
        -- Validate Country
        ----------------------------------------------------

        IF NOT EXISTS
        (
            SELECT 1
            FROM Master.CountryMaster
            WHERE CountryID=@CountryID
        )
        BEGIN
            THROW 50022,'Invalid Country.',1;
        END;

        ----------------------------------------------------
        -- Maintain Only One Primary Address
        ----------------------------------------------------

        IF @IsPrimary=1
        BEGIN
            UPDATE Customer.CustomerAddress
               SET IsPrimary=0,
                   ModifiedDate=SYSUTCDATETIME(),
                   ModifiedBy=@CreatedBy
             WHERE CustomerID=@CustomerID
               AND IsPrimary=1;
        END;

        ----------------------------------------------------
        -- Insert Address
        ----------------------------------------------------

        INSERT INTO Customer.CustomerAddress
        (
            CustomerID,
            AddressType,
            AddressLine1,
            AddressLine2,
            City,
            StateProvince,
            PostalCode,
            CountryID,
            IsPrimary,
            IsActive,
            CreatedDate,
            CreatedBy
        )
        VALUES
        (
            @CustomerID,
            @AddressType,
            @AddressLine1,
            @AddressLine2,
            @City,
            @StateProvince,
            @PostalCode,
            @CountryID,
            @IsPrimary,
            1,
            SYSUTCDATETIME(),
            @CreatedBy
        );

        DECLARE @CustomerAddressID INT = SCOPE_IDENTITY();

        COMMIT TRANSACTION;

        SELECT
            @CustomerAddressID AS CustomerAddressID,
            'Customer Address Created Successfully' AS Message;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH

END;
GO
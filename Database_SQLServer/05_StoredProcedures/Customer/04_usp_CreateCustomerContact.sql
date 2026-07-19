/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer
Procedure  : Customer.usp_CreateCustomerContact
Author     : Rakesh Soma
Purpose    : Create Customer Contact Information
******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Customer.usp_CreateCustomerContact
(
      @CustomerID                 INT
    , @ContactType                VARCHAR(30)
    , @ContactNumber              VARCHAR(20)
    , @EmailAddress               NVARCHAR(200)=NULL
    , @EmergencyContactName       NVARCHAR(100)=NULL
    , @EmergencyContactNumber     VARCHAR(20)=NULL
    , @PreferredContactMethod     VARCHAR(30)=NULL
    , @IsPrimary                  BIT=1
    , @CreatedBy                  NVARCHAR(100)
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
        WHERE CustomerID=@CustomerID
    )
    BEGIN
        THROW 50031,'Customer does not exist.',1;
    END;

    -------------------------------------------------------
    -- Only One Primary Contact
    -------------------------------------------------------

    IF @IsPrimary=1
    BEGIN
        UPDATE Customer.CustomerContact
           SET IsPrimary=0,
               ModifiedDate=SYSUTCDATETIME(),
               ModifiedBy=@CreatedBy
         WHERE CustomerID=@CustomerID;
    END;

    -------------------------------------------------------
    -- Insert Contact
    -------------------------------------------------------

    INSERT INTO Customer.CustomerContact
    (
        CustomerID,
        ContactType,
        ContactNumber,
        EmailAddress,
        EmergencyContactName,
        EmergencyContactNumber,
        PreferredContactMethod,
        IsPrimary,
        IsActive,
        CreatedDate,
        CreatedBy
    )
    VALUES
    (
        @CustomerID,
        @ContactType,
        @ContactNumber,
        @EmailAddress,
        @EmergencyContactName,
        @EmergencyContactNumber,
        @PreferredContactMethod,
        @IsPrimary,
        1,
        SYSUTCDATETIME(),
        @CreatedBy
    );

    DECLARE @CustomerContactID INT=SCOPE_IDENTITY();

    COMMIT TRANSACTION;

    SELECT
        @CustomerContactID AS CustomerContactID,
        'Customer Contact Created Successfully' AS Message;

END TRY

BEGIN CATCH

    IF @@TRANCOUNT>0
        ROLLBACK TRANSACTION;

    THROW;

END CATCH

END;
GO
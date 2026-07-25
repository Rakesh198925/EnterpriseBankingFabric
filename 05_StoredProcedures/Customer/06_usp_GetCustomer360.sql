/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer Management
Procedure  : Customer.usp_GetCustomer360
Author     : Rakesh Soma

Purpose:
    Returns a complete 360-degree customer profile.

******************************************************************************/

USE BankingERP;
GO

CREATE OR ALTER PROCEDURE Customer.usp_GetCustomer360
(
    @CustomerID INT
)
AS
BEGIN

    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1
        FROM Customer.Customer
        WHERE CustomerID = @CustomerID
    )
    BEGIN
        THROW 50020, 'Customer not found.', 1;
    END;

    SELECT

        C.CustomerID,
        C.CustomerNumber,
        C.FirstName,
        C.LastName,
        C.DateOfBirth,
        C.Gender,

        CT.CustomerTypeName,
        RC.RiskCategoryName,
        O.OccupationName,
        CO.CountryName,

        A.AddressLine1,
        A.AddressLine2,
        A.City,
        A.StateProvince,
        A.PostalCode,

        E.EmployerName,
        E.JobTitle,
        E.AnnualIncome,

        K.KYCStatus,
        K.KYCVerifiedDate,

        I.IdentityType,
        I.IdentityNumber,

        C.IsActive,
        C.CreatedDate

    FROM Customer.Customer C

    LEFT JOIN Master.CustomerTypeMaster CT
        ON C.CustomerTypeID = CT.CustomerTypeID

    LEFT JOIN Master.RiskCategoryMaster RC
        ON C.RiskCategoryID = RC.RiskCategoryID

    LEFT JOIN Master.CountryMaster CO
        ON C.CountryID = CO.CountryID

    LEFT JOIN Master.OccupationMaster O
        ON C.OccupationID = O.OccupationID

    LEFT JOIN Customer.CustomerAddress A
        ON C.CustomerID = A.CustomerID
       AND A.IsPrimary = 1

    LEFT JOIN Customer.CustomerEmployment E
        ON C.CustomerID = E.CustomerID

    LEFT JOIN Customer.CustomerKYC K
        ON C.CustomerID = K.CustomerID

    LEFT JOIN Customer.CustomerIdentity I
        ON C.CustomerID = I.CustomerID

    WHERE C.CustomerID = @CustomerID;

END;
GO
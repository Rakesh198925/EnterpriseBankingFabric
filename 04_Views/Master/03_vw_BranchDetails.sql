/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Branch Analytics
View       : Master.vw_BranchDetails
Author     : Rakesh Soma
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER VIEW Master.vw_BranchDetails
AS

SELECT

    B.BranchID,
    B.BranchCode,
    B.BranchName,

    C.CountryCode,
    C.CountryName,

    B.City,
    B.AddressLine1,
    B.PostalCode,

    B.IsActive,

    B.CreatedDate,
    B.CreatedBy


FROM Master.BranchMaster B

INNER JOIN Master.CountryMaster C
ON B.CountryID = C.CountryID;

GO
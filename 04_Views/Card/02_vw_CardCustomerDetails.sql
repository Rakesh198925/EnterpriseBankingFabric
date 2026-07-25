/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Card Analytics
View       : Card.vw_CardCustomerDetails
Author     : Rakesh Soma

Purpose:
    Customer card relationship details
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER VIEW Card.vw_CardCustomerDetails
AS


SELECT


CU.CustomerID,

CU.CustomerNumber,


CU.FirstName,

CU.LastName,


CA.CardID,

CA.CardNumber,


CT.CardTypeName,


CA.CardBrand,


CA.CardHolderName,


CA.CardStatus,


CA.IssueDate,


CA.ExpiryDate,


A.AccountNumber,


A.IBAN,


B.BranchName



FROM Customer.Customer CU


INNER JOIN Card.Card CA

ON CU.CustomerID = CA.CustomerID


LEFT JOIN Master.CardTypeMaster CT

ON CA.CardTypeID = CT.CardTypeID


LEFT JOIN Account.Account A

ON CA.AccountID = A.AccountID


LEFT JOIN Master.BranchMaster B

ON A.BranchID = B.BranchID;



GO
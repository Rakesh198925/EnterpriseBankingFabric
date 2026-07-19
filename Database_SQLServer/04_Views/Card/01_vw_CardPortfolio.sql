/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Card Analytics
View       : Card.vw_CardPortfolio
Author     : Rakesh Soma

Purpose:
    Card portfolio reporting
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER VIEW Card.vw_CardPortfolio
AS

SELECT

C.CardID,

C.CardNumber,


C.CustomerID,

CU.CustomerNumber,

CU.FirstName + ' ' + CU.LastName AS CustomerName,


CT.CardTypeCode,

CT.CardTypeName,


C.CardBrand,

C.CardHolderName,


C.IssueDate,

C.ExpiryDate,


C.CardStatus,


CASE

WHEN C.ExpiryDate < CAST(GETDATE() AS DATE)

THEN 'Expired'

WHEN C.CardStatus = 'BLOCKED'

THEN 'Blocked'

ELSE 'Active'

END AS CardHealthStatus,


C.ContactlessEnabled,

C.InternationalUsageEnabled,

C.OnlineUsageEnabled,

C.ATMUsageEnabled,


C.CreatedDate



FROM Card.Card C


INNER JOIN Customer.Customer CU

ON C.CustomerID = CU.CustomerID


LEFT JOIN Master.CardTypeMaster CT

ON C.CardTypeID = CT.CardTypeID;



GO
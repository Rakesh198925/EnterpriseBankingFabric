/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Card Analytics
View       : Card.vw_CardTransactionSummary
Author     : Rakesh Soma

Purpose:
    Card transaction analysis
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER VIEW Card.vw_CardTransactionSummary
AS


SELECT


CA.CardID,

CA.CardNumber,


CU.CustomerNumber,


CU.FirstName + ' ' + CU.LastName AS CustomerName,


COUNT(CT.CardTransactionID) AS TotalTransactions,


SUM(CT.TransactionAmount) AS TotalTransactionAmount,


MAX(CT.TransactionDate) AS LastTransactionDate,


CT.TransactionStatus,


CT.MerchantCategoryCode



FROM Card.Card CA


INNER JOIN Customer.Customer CU

ON CA.CustomerID = CU.CustomerID


LEFT JOIN Card.CardTransaction CT

ON CA.CardID = CT.CardID


GROUP BY


CA.CardID,

CA.CardNumber,

CU.CustomerNumber,

CU.FirstName,

CU.LastName,

CT.TransactionStatus,

CT.MerchantCategoryCode;



GO
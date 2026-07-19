/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Transaction Analytics
View       : Transactions.vw_TransactionDetails
Author     : Rakesh Soma

Purpose:
    Detailed transaction reporting
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER VIEW Transactions.vw_TransactionDetails
AS

SELECT

T.TransactionID,

T.TransactionReference,

A.AccountNumber,

A.IBAN,


C.CustomerID,

C.CustomerNumber,

C.FirstName + ' ' + C.LastName AS CustomerName,


TT.TransactionTypeCode,

TT.TransactionTypeName,

TT.TransactionCategory,


CM.CurrencyCode,


T.TransactionDate,

T.ValueDate,


T.Amount,


T.DebitCreditIndicator,


CASE
    WHEN T.DebitCreditIndicator = 'D'
        THEN 'Debit'
    WHEN T.DebitCreditIndicator = 'C'
        THEN 'Credit'
END AS TransactionDirection,


T.TransactionStatus,

T.Channel,


TD.MerchantName,

TD.MerchantCategoryCode,

TD.PaymentReference,

TD.RemittanceInformation,


T.Description,


T.CreatedDate


FROM Transactions.[Transaction] T


INNER JOIN Account.Account A

ON T.AccountID = A.AccountID


INNER JOIN Customer.Customer C

ON A.CustomerID = C.CustomerID


LEFT JOIN Master.TransactionTypeMaster TT

ON T.TransactionTypeID = TT.TransactionTypeID


LEFT JOIN Master.CurrencyMaster CM

ON T.CurrencyID = CM.CurrencyID


LEFT JOIN Transactions.TransactionDetail TD

ON T.TransactionID = TD.TransactionID;


GO
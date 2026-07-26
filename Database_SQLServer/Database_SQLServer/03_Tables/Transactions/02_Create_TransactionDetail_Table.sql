/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Transactions
Script     : 02_Create_TransactionDetail_Table.sql
Author     : Rakesh Soma
Purpose    : Create Transaction Detail table
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Transactions.TransactionDetail','U') IS NULL
BEGIN

CREATE TABLE Transactions.TransactionDetail
(
    TransactionDetailID BIGINT IDENTITY(1,1)
        CONSTRAINT PK_TransactionDetail PRIMARY KEY,

    TransactionID BIGINT NOT NULL,

    MerchantName NVARCHAR(200) NULL,

    MerchantCategoryCode VARCHAR(10) NULL,

    PaymentReference VARCHAR(100) NULL,

    EndToEndReference VARCHAR(100) NULL,

    RemittanceInformation NVARCHAR(500) NULL,

    AuthorizationCode VARCHAR(50) NULL,

    SettlementDate DATE NULL,

    CreatedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_TransactionDetail_Transaction
        FOREIGN KEY(TransactionID)
        REFERENCES Transactions.[Transaction](TransactionID)

);

END
GO
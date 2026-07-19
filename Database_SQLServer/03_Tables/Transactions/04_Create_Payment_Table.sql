/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Transactions
Script     : 04_Create_Payment_Table.sql
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Transactions.Payment','U') IS NULL
BEGIN

CREATE TABLE Transactions.Payment
(
    PaymentID BIGINT IDENTITY(1,1)
        CONSTRAINT PK_Payment PRIMARY KEY,

    TransactionID BIGINT NOT NULL,

    BeneficiaryID INT NOT NULL,

    PaymentMethod VARCHAR(30) NOT NULL,
        -- SEPA
        -- SEPA Instant
        -- SWIFT
        -- Internal Transfer

    PaymentStatus VARCHAR(30) NOT NULL,

    ExecutionDate DATETIME2,

    SettlementDate DATETIME2,

    ProcessingReference VARCHAR(100),

    CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_Payment_Transaction
        FOREIGN KEY(TransactionID)
        REFERENCES Transactions.[Transaction](TransactionID),

    CONSTRAINT FK_Payment_Beneficiary
        FOREIGN KEY(BeneficiaryID)
        REFERENCES Transactions.Beneficiary(BeneficiaryID)

);

END
GO
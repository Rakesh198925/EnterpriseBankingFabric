/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Loan
Script     : 04_Create_LoanPayment_Table.sql
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Loan.LoanPayment','U') IS NULL
BEGIN

CREATE TABLE Loan.LoanPayment
(
    LoanPaymentID BIGINT IDENTITY(1,1)
        CONSTRAINT PK_LoanPayment PRIMARY KEY,

    LoanID INT NOT NULL,

    AccountID INT NOT NULL,

    TransactionID BIGINT NULL,

    PaymentDate DATETIME2 NOT NULL,

    PaymentAmount DECIMAL(18,2) NOT NULL,

    PaymentMethod VARCHAR(30),

    PaymentStatus VARCHAR(30),

    CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_LoanPayment_Loan
        FOREIGN KEY(LoanID)
        REFERENCES Loan.Loan(LoanID),

    CONSTRAINT FK_LoanPayment_Account
        FOREIGN KEY(AccountID)
        REFERENCES Account.Account(AccountID),

    CONSTRAINT FK_LoanPayment_Transaction
        FOREIGN KEY(TransactionID)
        REFERENCES Transactions.[Transaction](TransactionID)

);

END
GO
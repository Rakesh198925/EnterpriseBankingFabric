/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Loan
Script     : 01_Create_Loan_Table.sql
Author     : Rakesh Soma
Purpose    : Create Loan table
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Loan.Loan','U') IS NULL
BEGIN

CREATE TABLE Loan.Loan
(
    LoanID INT IDENTITY(100000,1)
        CONSTRAINT PK_Loan PRIMARY KEY,

    LoanNumber VARCHAR(30) NOT NULL
        CONSTRAINT UQ_Loan_Number UNIQUE,

    CustomerID INT NOT NULL,

    AccountID INT NOT NULL,

    LoanTypeID INT NOT NULL,

    CurrencyID INT NOT NULL,

    PrincipalAmount DECIMAL(18,2) NOT NULL,

    OutstandingAmount DECIMAL(18,2) NOT NULL,

    InterestRate DECIMAL(6,3) NOT NULL,

    LoanTermMonths INT NOT NULL,

    StartDate DATE NOT NULL,

    MaturityDate DATE NOT NULL,

    LoanStatus VARCHAR(30) NOT NULL,

    CreatedDate DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    CreatedBy NVARCHAR(100) NOT NULL
        DEFAULT SUSER_SNAME(),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy NVARCHAR(100) NULL,

    CONSTRAINT FK_Loan_Customer
        FOREIGN KEY(CustomerID)
        REFERENCES Customer.Customer(CustomerID),

    CONSTRAINT FK_Loan_Account
        FOREIGN KEY(AccountID)
        REFERENCES Account.Account(AccountID),

    CONSTRAINT FK_Loan_LoanType
        FOREIGN KEY(LoanTypeID)
        REFERENCES Master.LoanTypeMaster(LoanTypeID),

    CONSTRAINT FK_Loan_Currency
        FOREIGN KEY(CurrencyID)
        REFERENCES Master.CurrencyMaster(CurrencyID)
);

END
GO
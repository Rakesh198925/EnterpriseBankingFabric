/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Loan
Script     : 02_Create_LoanApplication_Table.sql
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Loan.LoanApplication','U') IS NULL
BEGIN

CREATE TABLE Loan.LoanApplication
(
    LoanApplicationID INT IDENTITY(1,1)
        CONSTRAINT PK_LoanApplication PRIMARY KEY,

    CustomerID INT NOT NULL,

    LoanTypeID INT NOT NULL,

    RequestedAmount DECIMAL(18,2) NOT NULL,

    RequestedTermMonths INT NOT NULL,

    RequestedInterestRate DECIMAL(6,3) NULL,

    ApplicationDate DATE NOT NULL,

    ApplicationStatus VARCHAR(30) NOT NULL,

    DecisionDate DATE NULL,

    DecisionBy NVARCHAR(100) NULL,

    RejectionReason NVARCHAR(500) NULL,

    CreatedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_LoanApplication_Customer
        FOREIGN KEY(CustomerID)
        REFERENCES Customer.Customer(CustomerID),

    CONSTRAINT FK_LoanApplication_LoanType
        FOREIGN KEY(LoanTypeID)
        REFERENCES Master.LoanTypeMaster(LoanTypeID)

);

END
GO
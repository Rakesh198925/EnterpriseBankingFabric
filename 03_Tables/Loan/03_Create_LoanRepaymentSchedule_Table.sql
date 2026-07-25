/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Loan
Script     : 03_Create_LoanRepaymentSchedule_Table.sql
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Loan.LoanRepaymentSchedule','U') IS NULL
BEGIN

CREATE TABLE Loan.LoanRepaymentSchedule
(
    RepaymentScheduleID BIGINT IDENTITY(1,1)
        CONSTRAINT PK_LoanRepaymentSchedule PRIMARY KEY,

    LoanID INT NOT NULL,

    InstallmentNumber INT NOT NULL,

    DueDate DATE NOT NULL,

    PrincipalAmount DECIMAL(18,2) NOT NULL,

    InterestAmount DECIMAL(18,2) NOT NULL,

    TotalAmount DECIMAL(18,2) NOT NULL,

    OutstandingBalance DECIMAL(18,2) NOT NULL,

    PaymentStatus VARCHAR(30) DEFAULT 'Pending',

    CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_RepaymentSchedule_Loan
        FOREIGN KEY(LoanID)
        REFERENCES Loan.Loan(LoanID)

);

END
GO
/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Loan
Script     : 06_Create_LoanStatusHistory_Table.sql
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Loan.LoanStatusHistory','U') IS NULL
BEGIN

CREATE TABLE Loan.LoanStatusHistory
(
    LoanStatusHistoryID BIGINT IDENTITY(1,1)
        CONSTRAINT PK_LoanStatusHistory PRIMARY KEY,

    LoanID INT NOT NULL,

    PreviousStatus VARCHAR(30),

    CurrentStatus VARCHAR(30) NOT NULL,

    StatusReason NVARCHAR(500),

    EffectiveFrom DATETIME2 NOT NULL,

    EffectiveTo DATETIME2 NULL,

    ChangedBy NVARCHAR(100),

    CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_LoanStatusHistory_Loan
        FOREIGN KEY(LoanID)
        REFERENCES Loan.Loan(LoanID)

);

END
GO
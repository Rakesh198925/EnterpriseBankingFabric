/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Loan
Script     : 05_Create_Collateral_Table.sql
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Loan.Collateral','U') IS NULL
BEGIN

CREATE TABLE Loan.Collateral
(
    CollateralID INT IDENTITY(1,1)
        CONSTRAINT PK_Collateral PRIMARY KEY,

    LoanID INT NOT NULL,

    CollateralType VARCHAR(50),

    Description NVARCHAR(500),

    EstimatedValue DECIMAL(18,2),

    ValuationDate DATE,

    ValuationCompany NVARCHAR(200),

    CountryID INT,

    CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_Collateral_Loan
        FOREIGN KEY(LoanID)
        REFERENCES Loan.Loan(LoanID),

    CONSTRAINT FK_Collateral_Country
        FOREIGN KEY(CountryID)
        REFERENCES Master.CountryMaster(CountryID)

);

END
GO
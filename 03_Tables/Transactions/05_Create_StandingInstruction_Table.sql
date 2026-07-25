USE BankingERP;
GO

IF OBJECT_ID('Transactions.StandingInstruction','U') IS NULL
BEGIN

CREATE TABLE Transactions.StandingInstruction
(
    StandingInstructionID INT IDENTITY PRIMARY KEY,

    AccountID INT NOT NULL,

    BeneficiaryID INT NOT NULL,

    Amount DECIMAL(18,2) NOT NULL,

    Frequency VARCHAR(20),

    NextExecutionDate DATE,

    EndDate DATE,

    Status VARCHAR(20),

    CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_SI_Account
        FOREIGN KEY(AccountID)
        REFERENCES Account.Account(AccountID),

    CONSTRAINT FK_SI_Beneficiary
        FOREIGN KEY(BeneficiaryID)
        REFERENCES Transactions.Beneficiary(BeneficiaryID)

);

END
GO
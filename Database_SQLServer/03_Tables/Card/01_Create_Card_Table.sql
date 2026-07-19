/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Card
Script     : 01_Create_Card_Table.sql
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Card.Card','U') IS NULL
BEGIN

CREATE TABLE Card.Card
(
    CardID INT IDENTITY(1,1)
        CONSTRAINT PK_Card PRIMARY KEY,

    CardNumber VARCHAR(19) NOT NULL
        CONSTRAINT UQ_Card_Number UNIQUE,

    AccountID INT NOT NULL,

    CustomerID INT NOT NULL,

    CardTypeID INT NOT NULL,

    CardBrand VARCHAR(20) NOT NULL,

    CardHolderName NVARCHAR(150) NOT NULL,

    IssueDate DATE NOT NULL,

    ExpiryDate DATE NOT NULL,

    CardStatus VARCHAR(30) NOT NULL,

    ContactlessEnabled BIT DEFAULT 1,

    InternationalUsageEnabled BIT DEFAULT 1,

    OnlineUsageEnabled BIT DEFAULT 1,

    ATMUsageEnabled BIT DEFAULT 1,

    CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_Card_Account
        FOREIGN KEY(AccountID)
        REFERENCES Account.Account(AccountID),

    CONSTRAINT FK_Card_Customer
        FOREIGN KEY(CustomerID)
        REFERENCES Customer.Customer(CustomerID),

    CONSTRAINT FK_Card_CardType
        FOREIGN KEY(CardTypeID)
        REFERENCES Master.CardTypeMaster(CardTypeID)

);

END
GO
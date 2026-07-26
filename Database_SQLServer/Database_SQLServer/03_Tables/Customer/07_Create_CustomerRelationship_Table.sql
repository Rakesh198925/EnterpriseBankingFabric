/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer
Script     : 07_Create_CustomerRelationship_Table.sql
Author     : Rakesh Soma
Purpose    : Create Customer Relationship table
******************************************************************************/

USE BankingERP;
GO

PRINT '=============================================';
PRINT 'CREATING CUSTOMER.CUSTOMERRELATIONSHIP TABLE';
PRINT '=============================================';
GO

IF OBJECT_ID('Customer.CustomerRelationship','U') IS NULL
BEGIN

CREATE TABLE Customer.CustomerRelationship
(
    CustomerRelationshipID INT IDENTITY(1,1)
        CONSTRAINT PK_CustomerRelationship PRIMARY KEY,

    CustomerID INT NOT NULL,

    RelatedCustomerID INT NOT NULL,

    RelationshipType VARCHAR(50) NOT NULL,
        -- Spouse, Parent, Child, Joint Holder,
        -- Beneficial Owner, Power of Attorney

    StartDate DATE NULL,

    EndDate DATE NULL,

    IsActive BIT NOT NULL DEFAULT 1,

    CreatedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CreatedBy NVARCHAR(100) NOT NULL DEFAULT SUSER_SNAME(),

    ModifiedDate DATETIME2 NULL,

    ModifiedBy NVARCHAR(100) NULL,

    CONSTRAINT FK_CustomerRelationship_Customer
        FOREIGN KEY(CustomerID)
        REFERENCES Customer.Customer(CustomerID),

    CONSTRAINT FK_CustomerRelationship_RelatedCustomer
        FOREIGN KEY(RelatedCustomerID)
        REFERENCES Customer.Customer(CustomerID)
);

END
GO
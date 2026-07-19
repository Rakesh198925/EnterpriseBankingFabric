/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer
Script     : 09_Create_CustomerAudit_Table.sql
Author     : Rakesh Soma
Purpose    : Create Customer Audit table
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Customer.CustomerAudit','U') IS NULL
BEGIN

CREATE TABLE Customer.CustomerAudit
(
    CustomerAuditID BIGINT IDENTITY(1,1)
        CONSTRAINT PK_CustomerAudit PRIMARY KEY,

    CustomerID INT NOT NULL,

    AuditAction VARCHAR(30) NOT NULL,
        -- Insert
        -- Update
        -- Delete
        -- KYC Review
        -- Status Change

    ChangedColumn NVARCHAR(100),

    OldValue NVARCHAR(1000),

    NewValue NVARCHAR(1000),

    ChangedBy NVARCHAR(100) NOT NULL,

    ChangedDate DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),

    SourceSystem VARCHAR(50) DEFAULT 'SQL Server',

    CONSTRAINT FK_CustomerAudit_Customer
        FOREIGN KEY(CustomerID)
        REFERENCES Customer.Customer(CustomerID)
);

END
GO



--------------------Validate Customer Module---------------

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA='Customer'
ORDER BY TABLE_NAME;
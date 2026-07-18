USE BankingERP;
GO

SELECT 
    name AS SchemaName
FROM sys.schemas
WHERE name IN
(
    'Master',
    'Customer',
    'Account',
    'Transaction',
    'Loan',
    'Card',
    'Audit'
);
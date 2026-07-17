USE BankingERP;
GO

PRINT '=============================================';
PRINT 'CREATING CUSTOMER SCHEMA';
PRINT '=============================================';

IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name = 'Customer'
)
BEGIN
    EXEC('CREATE SCHEMA Customer');
    PRINT 'Customer schema created successfully.';
END
ELSE
BEGIN
    PRINT 'Customer schema already exists.';
END
GO



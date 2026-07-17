/******************************************************************************
Project      : Enterprise Banking Data Platform
Module       : Master Data
Schema       : Master
Table        : LoanTypeMaster
Author       : Rakesh Soma
Version      : 2.0
******************************************************************************/

USE BankingERP;
GO

IF OBJECT_ID('Master.LoanTypeMaster','U') IS NOT NULL
    DROP TABLE Master.LoanTypeMaster;
GO

CREATE TABLE Master.LoanTypeMaster
(
    LoanTypeID INT IDENTITY(1,1)
        CONSTRAINT PK_LoanTypeMaster PRIMARY KEY CLUSTERED,

    LoanTypeCode VARCHAR(20) NOT NULL,

    LoanTypeName VARCHAR(100) NOT NULL,

    MinInterestRate DECIMAL(5,2) NOT NULL,

    MaxInterestRate DECIMAL(5,2) NOT NULL,

    MaxTenureMonths INT NOT NULL,

    Description VARCHAR(250) NULL,

    IsActive BIT NOT NULL
        CONSTRAINT DF_LoanTypeMaster_IsActive DEFAULT(1),

    CreatedDate DATETIME2(7) NOT NULL
        CONSTRAINT DF_LoanTypeMaster_CreatedDate DEFAULT(SYSDATETIME()),

    CreatedBy SYSNAME NOT NULL
        CONSTRAINT DF_LoanTypeMaster_CreatedBy DEFAULT(SUSER_SNAME()),

    ModifiedDate DATETIME2(7) NULL,

    ModifiedBy SYSNAME NULL,

    CONSTRAINT UQ_LoanTypeMaster_Code UNIQUE(LoanTypeCode),

    CONSTRAINT UQ_LoanTypeMaster_Name UNIQUE(LoanTypeName),

    CONSTRAINT CK_LoanTypeMaster_Interest
        CHECK(MinInterestRate>=0
          AND MaxInterestRate>=MinInterestRate),

    CONSTRAINT CK_LoanTypeMaster_Tenure
        CHECK(MaxTenureMonths BETWEEN 6 AND 480)
);
GO

CREATE INDEX IX_LoanTypeMaster_Code
ON Master.LoanTypeMaster(LoanTypeCode);

CREATE INDEX IX_LoanTypeMaster_Name
ON Master.LoanTypeMaster(LoanTypeName);

CREATE INDEX IX_LoanTypeMaster_IsActive
ON Master.LoanTypeMaster(IsActive);
GO


-------Insert Data---------


INSERT INTO Master.LoanTypeMaster
(
LoanTypeCode,
LoanTypeName,
MinInterestRate,
MaxInterestRate,
MaxTenureMonths,
Description
)
VALUES
('HOME','Home Loan',7.50,9.50,360,'Housing Loan'),
('AUTO','Auto Loan',8.00,11.00,84,'Vehicle Loan'),
('PL','Personal Loan',10.50,18.00,60,'Personal Finance'),
('EDU','Education Loan',6.50,10.00,180,'Higher Education'),
('GL','Gold Loan',7.00,12.00,36,'Gold Secured Loan');
GO


-------Validation-----------


/******************************************************************************
Validation - LoanTypeMaster
******************************************************************************/

-- 1. Verify Table Structure
EXEC sp_help 'Master.LoanTypeMaster';
GO

-- 2. Verify Indexes
EXEC sp_helpindex 'Master.LoanTypeMaster';
GO

-- 3. Verify Constraints
EXEC sp_helpconstraint 'Master.LoanTypeMaster';
GO

-- 4. Verify Data
SELECT *
FROM Master.LoanTypeMaster
ORDER BY LoanTypeName;
GO

-- 5. Total Records
SELECT COUNT(*) AS TotalLoanTypes
FROM Master.LoanTypeMaster;
GO

-- 6. Active Loan Types
SELECT *
FROM Master.LoanTypeMaster
WHERE IsActive = 1;
GO

-- 7. Interest Rate Validation
SELECT
    LoanTypeCode,
    LoanTypeName,
    MinInterestRate,
    MaxInterestRate
FROM Master.LoanTypeMaster
ORDER BY MinInterestRate;
GO

-- 8. Maximum Tenure Validation
SELECT
    LoanTypeName,
    MaxTenureMonths
FROM Master.LoanTypeMaster
ORDER BY MaxTenureMonths DESC;
GO

-- 9. Duplicate Code Check
SELECT
    LoanTypeCode,
    COUNT(*) AS Total
FROM Master.LoanTypeMaster
GROUP BY LoanTypeCode
HAVING COUNT(*) > 1;
GO

-- 10. Duplicate Name Check-----
/******************************************************************************
Validation - LoanTypeMaster
******************************************************************************/

-- 1. Verify Table Structure
EXEC sp_help 'Master.LoanTypeMaster';
GO

-- 2. Verify Indexes
EXEC sp_helpindex 'Master.LoanTypeMaster';
GO

-- 3. Verify Constraints
EXEC sp_helpconstraint 'Master.LoanTypeMaster';
GO

-- 4. Verify Data
SELECT *
FROM Master.LoanTypeMaster
ORDER BY LoanTypeName;
GO

-- 5. Total Records
SELECT COUNT(*) AS TotalLoanTypes
FROM Master.LoanTypeMaster;
GO

-- 6. Active Loan Types
SELECT *
FROM Master.LoanTypeMaster
WHERE IsActive = 1;
GO

-- 7. Interest Rate Validation
SELECT
    LoanTypeCode,
    LoanTypeName,
    MinInterestRate,
    MaxInterestRate
FROM Master.LoanTypeMaster
ORDER BY MinInterestRate;
GO

-- 8. Maximum Tenure Validation
SELECT
    LoanTypeName,
    MaxTenureMonths
FROM Master.LoanTypeMaster
ORDER BY MaxTenureMonths DESC;
GO

-- 9. Duplicate Code Check
SELECT
    LoanTypeCode,
    COUNT(*) AS Total
FROM Master.LoanTypeMaster
GROUP BY LoanTypeCode
HAVING COUNT(*) > 1;
GO

-- 10. Duplicate Name Check
SELECT
    LoanTypeName,
    COUNT(*) AS Total
FROM Master.LoanTypeMaster
GROUP BY LoanTypeName
HAVING COUNT(*) > 1;
GO

-- 11. Null Check
SELECT *
FROM Master.LoanTypeMaster
WHERE LoanTypeCode IS NULL
   OR LoanTypeName IS NULL;
GO
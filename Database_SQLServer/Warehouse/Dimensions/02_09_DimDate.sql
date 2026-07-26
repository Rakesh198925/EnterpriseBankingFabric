/*==============================================================================
 Project      : Enterprise Banking Fabric
 Layer        : Enterprise Data Warehouse
 Script Name  : 02_09_DimDate.sql
 Description  : Creates and Populates Date Dimension
==============================================================================*/

USE BankingERP;
GO

/*==============================================================
Drop Existing Table
==============================================================*/

IF OBJECT_ID('Dim.DimDate','U') IS NOT NULL
    DROP TABLE Dim.DimDate;
GO

/*==============================================================
Create Table
==============================================================*/

CREATE TABLE Dim.DimDate
(
    DateKey INT NOT NULL PRIMARY KEY,

    FullDate DATE NOT NULL,

    DayNumber TINYINT,

    DayName VARCHAR(20),

    DayOfWeekNumber TINYINT,

    WeekNumber TINYINT,

    MonthNumber TINYINT,

    MonthName VARCHAR(20),

    QuarterNumber TINYINT,

    QuarterName VARCHAR(10),

    YearNumber SMALLINT,

    FiscalYear SMALLINT,

    FiscalQuarter VARCHAR(10),

    IsWeekend BIT,

    IsMonthEnd BIT,

    IsQuarterEnd BIT,

    IsYearEnd BIT
);
GO

/*==============================================================
Populate Date Dimension
==============================================================*/

DECLARE @StartDate DATE='2000-01-01';
DECLARE @EndDate DATE='2050-12-31';

WHILE @StartDate<=@EndDate
BEGIN

INSERT INTO Dim.DimDate
(
DateKey,
FullDate,
DayNumber,
DayName,
DayOfWeekNumber,
WeekNumber,
MonthNumber,
MonthName,
QuarterNumber,
QuarterName,
YearNumber,
FiscalYear,
FiscalQuarter,
IsWeekend,
IsMonthEnd,
IsQuarterEnd,
IsYearEnd
)

VALUES
(

CONVERT(INT,FORMAT(@StartDate,'yyyyMMdd')),

@StartDate,

DAY(@StartDate),

DATENAME(WEEKDAY,@StartDate),

DATEPART(WEEKDAY,@StartDate),

DATEPART(WEEK,@StartDate),

MONTH(@StartDate),

DATENAME(MONTH,@StartDate),

DATEPART(QUARTER,@StartDate),

'Q'+CAST(DATEPART(QUARTER,@StartDate) AS VARCHAR(1)),

YEAR(@StartDate),

YEAR(@StartDate),

'Q'+CAST(DATEPART(QUARTER,@StartDate) AS VARCHAR(1)),

CASE
WHEN DATENAME(WEEKDAY,@StartDate) IN ('Saturday','Sunday')
THEN 1 ELSE 0
END,

CASE
WHEN @StartDate=EOMONTH(@StartDate)
THEN 1 ELSE 0
END,

CASE
WHEN MONTH(@StartDate) IN (3,6,9,12)
AND @StartDate=EOMONTH(@StartDate)
THEN 1 ELSE 0
END,

CASE
WHEN MONTH(@StartDate)=12
AND DAY(@StartDate)=31
THEN 1 ELSE 0
END

);

SET @StartDate=DATEADD(DAY,1,@StartDate);

END
GO

PRINT 'DimDate Loaded Successfully';
GO
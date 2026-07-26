/*==============================================================================
 Project      : Enterprise Banking Fabric
 Layer        : Enterprise Data Warehouse
 Script Name  : 02_10_DimTime.sql
 Description  : Creates and Populates Time Dimension
==============================================================================*/

USE BankingERP;
GO

/*==============================================================
 Drop Existing Table
==============================================================*/

IF OBJECT_ID('Dim.DimTime','U') IS NOT NULL
    DROP TABLE Dim.DimTime;
GO

/*==============================================================
 Create Table
==============================================================*/

CREATE TABLE Dim.DimTime
(
    TimeKey INT NOT NULL PRIMARY KEY,

    FullTime TIME(0) NOT NULL,

    Hour24 TINYINT NOT NULL,

    Hour12 TINYINT NOT NULL,

    MinuteNumber TINYINT NOT NULL,

    SecondNumber TINYINT NOT NULL,

    AMPM CHAR(2),

    TimeBucket VARCHAR(20)
);
GO

/*==============================================================
 Populate Time Dimension
==============================================================*/

DECLARE @Time TIME='00:00:00';

WHILE @Time<='23:59:59'
BEGIN

INSERT INTO Dim.DimTime
(
TimeKey,
FullTime,
Hour24,
Hour12,
MinuteNumber,
SecondNumber,
AMPM,
TimeBucket
)

VALUES
(

DATEPART(HOUR,@Time)*10000+
DATEPART(MINUTE,@Time)*100+
DATEPART(SECOND,@Time),

@Time,

DATEPART(HOUR,@Time),

CASE
WHEN DATEPART(HOUR,@Time)=0 THEN 12
WHEN DATEPART(HOUR,@Time)<=12 THEN DATEPART(HOUR,@Time)
ELSE DATEPART(HOUR,@Time)-12
END,

DATEPART(MINUTE,@Time),

DATEPART(SECOND,@Time),

CASE
WHEN DATEPART(HOUR,@Time)<12
THEN 'AM'
ELSE 'PM'
END,

CASE
WHEN DATEPART(HOUR,@Time) BETWEEN 5 AND 11 THEN 'Morning'
WHEN DATEPART(HOUR,@Time) BETWEEN 12 AND 16 THEN 'Afternoon'
WHEN DATEPART(HOUR,@Time) BETWEEN 17 AND 20 THEN 'Evening'
ELSE 'Night'
END

);

SET @Time=DATEADD(SECOND,1,@Time);

END
GO

PRINT 'DimTime Loaded Successfully';
GO
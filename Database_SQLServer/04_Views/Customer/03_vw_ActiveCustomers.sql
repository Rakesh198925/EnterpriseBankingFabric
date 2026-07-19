/******************************************************************************
Project    : Enterprise Banking Data Platform
Module     : Customer Analytics
View       : Customer.vw_ActiveCustomers
Author     : Rakesh Soma
******************************************************************************/

USE BankingERP;
GO


CREATE OR ALTER VIEW Customer.vw_ActiveCustomers
AS


SELECT


C.CustomerID,

C.CustomerNumber,


C.FirstName,

C.LastName,


CT.CustomerTypeName,


RC.RiskName,


C.CustomerStatus,

C.KYCStatus,


C.EmailAddress,

C.MobileNumber,


C.CreatedDate


FROM Customer.Customer C


LEFT JOIN Master.CustomerTypeMaster CT

ON C.CustomerTypeID = CT.CustomerTypeID


LEFT JOIN Master.RiskCategoryMaster RC

ON C.RiskCategoryID = RC.RiskCategoryID


WHERE C.IsActive = 1;


GO
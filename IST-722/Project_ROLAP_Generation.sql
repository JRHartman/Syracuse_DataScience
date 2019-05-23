/****** Object:  Database UNKNOWN    Script Date: 3/7/2019 7:16:16 PM ******/
/*
Kimball Group, The Microsoft Data Warehouse Toolkit
Generate a database from the datamodel worksheet, version: 4

You can use this Excel workbook as a data modeling tool during the logical design phase of your project.
As discussed in the book, it is in some ways preferable to a real data modeling tool during the inital design.
We expect you to move away from this spreadsheet and into a real modeling tool during the physical design phase.
The authors provide this macro so that the spreadsheet isn't a dead-end. You can 'import' into your
data modeling tool by generating a database using this script, then reverse-engineering that database into
your tool.

Uncomment the next lines if you want to drop and create the database
*/
/*
DROP DATABASE UNKNOWN
GO
CREATE DATABASE UNKNOWN
GO
ALTER DATABASE UNKNOWN
SET RECOVERY SIMPLE
GO
*/
USE ist722_hhkhan_oa3_dw
;
IF EXISTS (SELECT Name from sys.extended_properties where Name = 'Description')
    EXEC sys.sp_dropextendedproperty @name = 'Description'
EXEC sys.sp_addextendedproperty @name = 'Description', @value = 'Default description - you should change this.'
;


/* Drop table dbo.FactFFRecommendation */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.FactFFRecommendation') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.FactFFRecommendation 
;

/* Create table dbo.FactFFRecommendation */
CREATE TABLE dbo.FactFFRecommendation (
   [CustomerKey]  int  DEFAULT  NULL
,  [MovieKey]  int  DEFAULT NULL
,  [InsertAuditKey]  int  DEFAULT NULL
,  [UpdateAuditKey]  int  DEFAULT  NULL
,  [MovieAvgRating]  decimal(18,2)   NULL
,  [MovieRuntime]  int   NULL
,  [YearsOld]  int   NULL
, CONSTRAINT [PK_dbo.FactFFRecommendation] PRIMARY KEY NONCLUSTERED 
( [MovieKey], [CustomerKey] )
) ON [PRIMARY]
;

/* Drop table dbo.FactFFSubscriptions */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.FactFFSubscriptions') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.FactFFSubscriptions 
;

/* Create table dbo.FactFFSubscriptions */
CREATE TABLE dbo.FactFFSubscriptions (
   [CustomerKey]  int  DEFAULT NULL
,  [PlanKey]  int  DEFAULT NULL
,  [InsertAuditKey]  int  DEFAULT NULL
,  [UpdateAuditKey]  int  DEFAULT NULL
,  [PlanPrice]  money   NULL
,  [MonthsOpened] int NULL
, CONSTRAINT [PK_dbo.FactFFSubscriptions] PRIMARY KEY NONCLUSTERED 
( [PlanKey], [CustomerKey] )
) ON [PRIMARY]
;

/* Drop table dbo.FactFMSales */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.FactFMSales') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.FactFMSales 
;

/* Create table dbo.FactFMSales */
CREATE TABLE dbo.FactFMSales (
   [CustomerKey]  int  DEFAULT NULL
,  [ProductKey]  int  DEFAULT NULL
,  [InsertAuditKey]  int  DEFAULT NULL
,  [UpdateAuditKey]  int  DEFAULT NULL
,  [OrderID] int NOT NULL
,  [SalesRevenue]  decimal(30,4)   NULL
,  [SalesProfit]  decimal(30,4)   NULL
,  [SalesQuantity]  int   NULL
,  [RetailPrice]  money   NULL
,  [WholesalePrice]  money   NULL
, CONSTRAINT [PK_dbo.FactFMSales] PRIMARY KEY NONCLUSTERED 
( [OrderID], [ProductKey] )
) ON [PRIMARY]
;

/* Drop table dbo.FactFMFulfillment */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.FactFMFulfillment') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.FactFMFulfillment 
;

/* Create table dbo.FactFMFulfillment */
CREATE TABLE dbo.FactFMFulfillment (
   [CustomerKey]  int  DEFAULT NULL
,  [OrderDateKey]  int  DEFAULT NULL
,  [ShippedDateKey]  int  DEFAULT NULL
,  [InsertAuditKey]  int  DEFAULT NULL
,  [UpdateAuditKey]  int  DEFAULT NULL
,  [OrderID] int NOT NULL
,  [FulfillmentLagInDays]  int   NULL
,  [ShippedVia]  varchar(20)   NULL
, CONSTRAINT [PK_dbo.FactFMFulfillment] PRIMARY KEY NONCLUSTERED 
( [OrderID], [OrderDateKey] )
) ON [PRIMARY]
;

/* Drop table dbo.FactItemAnalysis */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.FactItemAnalysis') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.FactItemAnalysis 
;

/* Create table dbo.FactItemAnalysis */
CREATE TABLE dbo.FactItemAnalysis (
   [CustomerKey]  int  DEFAULT NULL
,  [ProductKey]  int  DEFAULT NULL
,  [PlanKey]  int  DEFAULT NULL
,  [InsertAuditKey]  int  DEFAULT NULL
,  [UpdateAuditKey]  int  DEFAULT NULL
,  [RetailPrice]  money   NULL
,  [PlanPrice] money NULL
, CONSTRAINT [PK_dbo.FactItemAnalysis] PRIMARY KEY NONCLUSTERED 
( [CustomerKey], [PlanKey], [ProductKey] )
) ON [PRIMARY]
;


/* Drop table dbo.DimCustomer */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimCustomer') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimCustomer 
;

/* Create table dbo.DimCustomer */
CREATE TABLE dbo.DimCustomer (
   [CustomerKey]  int IDENTITY  NOT NULL
,  [CustomerEmail]  varchar(200) NOT NULL
,  [CustomerFirstName]  varchar(50)   NOT NULL
,  [CustomerLastName]  varchar(50)   NOT NULL
,  [CustomerAddress]  nvarchar(1000) NOT NULL
,  [CustomerZip]  varchar(5)   NOT NULL
,  [RowIsCurrent]  bit DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200) DEFAULT 'N/A' NOT NULL
, CONSTRAINT [PK_dbo.DimCustomer] PRIMARY KEY CLUSTERED 
( [CustomerKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT dbo.DimCustomer ON
;
INSERT INTO dbo.DimCustomer (CustomerKey, CustomerEmail, CustomerFirstName, CustomerLastName, CustomerAddress, CustomerZip, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, 'Unknown Email', 'Unknown Member', 'Unknown Member', 'Unknown Address', 'N/A', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT dbo.DimCustomer OFF
;

/* Drop table dbo.DimProduct */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimProduct') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimProduct 
;

/* Create table dbo.DimProduct */
CREATE TABLE dbo.DimProduct (
   [ProductKey]  int IDENTITY  NOT NULL
,  [ProductID]  int   NOT NULL
,  [ProductName]  varchar(50)   NOT NULL
,  [ProductDepartment]  varchar(50)   NOT NULL
,  [RowIsCurrent]  bit DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200) DEFAULT 'N/A' NOT NULL
, CONSTRAINT [PK_dbo.DimProduct] PRIMARY KEY CLUSTERED 
( [ProductKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT dbo.DimProduct ON
;
INSERT INTO dbo.DimProduct (ProductKey, ProductID, ProductName, ProductDepartment, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'Unknown Name', 'Unknown Department', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT dbo.DimProduct OFF
;

/* Drop table dbo.DimMovie */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimMovie') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimMovie 
;

/* Create table dbo.DimMovie */
CREATE TABLE dbo.DimMovie (
   [MovieKey]  int IDENTITY  NOT NULL
,  [MovieID]  varchar(20)  NOT NULL
,  [MovieName]  varchar(200)   NOT NULL
,  [MovieRating]  varchar(200)   NOT NULL
,  [MovieGenre]  varchar(200)   NULL
,  [RowIsCurrent]  bit DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200) DEFAULT 'N/A' NOT NULL
, CONSTRAINT [PK_dbo.DimMovie] PRIMARY KEY CLUSTERED 
( [MovieKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT dbo.DimMovie ON
;
INSERT INTO dbo.DimMovie (MovieKey, MovieID, MovieName, MovieRating, MovieGenre, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, 'Unknown ID', 'Unknown Name', 'Unknown Rating', 'Unknown Genre', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT dbo.DimMovie OFF
;

/* Drop table dbo.DimSubscriptionPlan */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimSubscriptionPlan') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimSubscriptionPlan 
;

/* Create table dbo.DimSubscriptionPlan */
CREATE TABLE dbo.DimSubscriptionPlan (
   [PlanKey]  int IDENTITY
,  [PlanID]  int   NOT NULL
,  [PlanName]  varchar(50)  NOT NULL
,  [PlanCurrent]  nchar(1)   NOT NULL
,  [RowIsCurrent]  bit DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200) DEFAULT 'N/A' NOT NULL
, CONSTRAINT [PK_dbo.DimSubscriptionPlan] PRIMARY KEY CLUSTERED 
( [PlanKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT dbo.DimSubscriptionPlan ON
;
INSERT INTO dbo.DimSubscriptionPlan (PlanKey, PlanID, PlanName, PlanCurrent, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'Unknown Plan', 'N', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT dbo.DimSubscriptionPlan OFF
;


/* Drop table dbo.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'northwind.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimDate 
;

/* Create table northwind.DimDate */
CREATE TABLE dbo.DimDate (
   [DateKey]  int   NOT NULL
,  [Date]  datetime   NULL
,  [FullDateUSA]  nchar(11)   NOT NULL
,  [DayOfWeek]  tinyint   NOT NULL
,  [DayName]  nchar(10)   NOT NULL
,  [DayOfMonth]  tinyint   NOT NULL
,  [DayOfYear]  int   NOT NULL
,  [WeekOfYear]  tinyint   NOT NULL
,  [MonthName]  nchar(10)   NOT NULL
,  [MonthOfYear]  tinyint   NOT NULL
,  [Quarter]  tinyint   NOT NULL
,  [QuarterName]  nchar(10)   NOT NULL
,  [Year]  int   NOT NULL
,  [IsWeekday]  bit  DEFAULT 0 NOT NULL
, CONSTRAINT [PK_northwind.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;

INSERT INTO dbo.DimDate (DateKey, Date, FullDateUSA, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsWeekday)
VALUES (-1, '', 'Unk date', 0, 'Unk date', 0, 0, 0, 'Unk month', 0, 0, 'Unk qtr', 0, 0)
;

ALTER TABLE dbo.FactFFRecommendation ADD CONSTRAINT
   FK_dbo_FactFFRecommendation_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactFFRecommendation ADD CONSTRAINT
   FK_dbo_FactFFRecommendation_MovieKey FOREIGN KEY
   (
   MovieKey
   ) REFERENCES DimMovie
   ( MovieKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactFFRecommendation ADD CONSTRAINT
   FK_dbo_FactFFRecommendation_InsertAuditKey FOREIGN KEY
   (
   InsertAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactFFRecommendation ADD CONSTRAINT
   FK_dbo_FactFFRecommendation_UpdateAuditKey FOREIGN KEY
   (
   UpdateAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactFFSubscriptions ADD CONSTRAINT
   FK_dbo_FactFFSubscriptions_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactFFSubscriptions ADD CONSTRAINT
   FK_dbo_FactFFSubscriptions_PlanKey FOREIGN KEY
   (
   PlanKey
   ) REFERENCES DimSubscriptionPlan
   ( PlanKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactFFSubscriptions ADD CONSTRAINT
   FK_dbo_FactFFSubscriptions_InsertAuditKey FOREIGN KEY
   (
   InsertAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactFFSubscriptions ADD CONSTRAINT
   FK_dbo_FactFFSubscriptions_UpdateAuditKey FOREIGN KEY
   (
   UpdateAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactFMSales ADD CONSTRAINT
   FK_dbo_FactFMSales_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactFMSales ADD CONSTRAINT
   FK_dbo_FactFMSales_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES DimProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactFMSales ADD CONSTRAINT
   FK_dbo_FactFMSales_InsertAuditKey FOREIGN KEY
   (
   InsertAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactFMSales ADD CONSTRAINT
   FK_dbo_FactFMSales_UpdateAuditKey FOREIGN KEY
   (
   UpdateAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactFMFulfillment ADD CONSTRAINT
   FK_dbo_FactFMFulfillment_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactFMFulfillment ADD CONSTRAINT
   FK_dbo_FactFMFulfillment_OrderDateKey FOREIGN KEY
   (
   OrderDateKey
   ) REFERENCES DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactFMFulfillment ADD CONSTRAINT
   FK_dbo_FactFMFulfillment_ShippedDateKey FOREIGN KEY
   (
   ShippedDateKey
   ) REFERENCES DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactFMFulfillment ADD CONSTRAINT
   FK_dbo_FactFMFulfillment_InsertAuditKey FOREIGN KEY
   (
   InsertAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactFMFulfillment ADD CONSTRAINT
   FK_dbo_FactFMFulfillment_UpdateAuditKey FOREIGN KEY
   (
   UpdateAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactItemAnalysis ADD CONSTRAINT
   FK_dbo_FactItemAnalysis_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactItemAnalysis ADD CONSTRAINT
   FK_dbo_FactItemAnalysis_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES DimProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactItemAnalysis ADD CONSTRAINT
   FK_dbo_FactItemAnalysis_MovieKey FOREIGN KEY
   (
   MovieKey
   ) REFERENCES DimMovie
   ( MovieKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactItemAnalysis ADD CONSTRAINT
   FK_dbo_FactItemAnalysis_InsertAuditKey FOREIGN KEY
   (
   InsertAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactItemAnalysis ADD CONSTRAINT
   FK_dbo_FactItemAnalysis_UpdateAuditKey FOREIGN KEY
   (
   UpdateAuditKey
   ) REFERENCES DimAudit
   ( AuditKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 

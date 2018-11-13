use BIClass
go

IF NOT EXISTS ( SELECT  * FROM    sys.schemas WHERE name = N'Process' ) 
    EXEC('CREATE SCHEMA Process AUTHORIZATION [dbo]');
GO
drop table if exists Process.WorkflowSteps;

/*  id for the person,
	LastName varchar(30) NULL DEFAULT ('Your last name'),
	FirstName varchar(30) NULL DEFAULT ('Your first name'),
	class time of the person (char[5]) 7:45’, ‘9:15’ or ’10:45’),
	date of work (systime),
	what the person did,
	GroupName varchar(30) NULL DEFAULT ('Your group name')*/

create table Process.WorkflowSteps(
			 WorkFlowStepKey INT IDENTITY(1,1) NOT NULL
		    ,DateAdded datetime2 not null default sysdatetime()
			,WorkFlowStepDescription NVARCHAR(100) NOT NULL
			,WorkFlowStepTableRowCount INT NULL DEFAULT (0)
			,StartingDateTime DATETIME2(7) NULL DEFAULT (SYSDATETIME())
			,EndingDateTime DATETIME2(7) NULL DEFAULT (SYSDATETIME())
			,ClassTime CHAR(5) NULL DEFAULT ('09:15')
			,lastName varchar(30) not null default 'Khodjayev' -- individual table
		    ,firstName varchar(30) not null default 'Dilshod' -- individual table
			,GroupName varchar(30) NULL DEFAULT ('group #2') -- for the group
		  );

		select * from sys.tables
		select * into dbo.tempTable from [CH01-01-Fact].Data
		select * into [CH01-01-Fact].Data from dbo.tempTable

		--/////////////////////////////////////////////////////////////
		truncate table [CH01-01-Fact].Data; --first turnicate
		alter table [CH01-01-Fact].Data add classTime varchar(5) default '0900-1045',
		                                    LastName varchar(30) DEFAULT ('Dilshod'),
											FirstName varchar(30) DEFAULT ('Khodjayev'),
											DateAdded datetime2 default sysdatetime();
			
		--/////////////////////////////////////////////////////////////
		exec [Project1].[DropForeignKeysFromStarSchemaData]
		exec [Project1].[TruncateStarSchemaData]


insert into [CH01-01-Fact].Data
SELECT
  SalesManagerKey,
  OccupationKey,
  TerritoryKey,
  ProductKey,
  CustomerKey,
  ProductCategory,
  SalesManager,
  ProductSubcategory,
  ProductCode,
  ProductName,
  Color,
  ModelName,
  OrderQuantity,
  UnitPrice,
  ProductStandardCost,
  SalesAmount,
  OrderDate,
  MonthName,
  MonthNumber,
  Year,
  CustomerName,
  MaritalStatus,
  Gender,
  Education,
  Occupation,
  TerritoryRegion,
  TerritoryCountry,
  TerritoryGroup
FROM tempTable


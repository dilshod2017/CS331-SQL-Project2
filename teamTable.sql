use BIClass
go

IF NOT EXISTS ( SELECT  * FROM    sys.schemas WHERE name = N'Process' ) 
    EXEC('CREATE SCHEMA Process AUTHORIZATION [dbo]');
GO

drop table if exists Process.WorkflowSteps;

create table Process.WorkflowSteps(
			 WorkFlowStepKey INT IDENTITY(1,1) NOT NULL
		    ,DateAdded datetime2 null default sysdatetime()
			,WorkFlowStepDescription NVARCHAR(max) NOT NULL
			,WorkFlowStepTableRowCount INT NULL DEFAULT (0)
			,StartingDateTime DATETIME2(7) NULL DEFAULT (SYSDATETIME())
			,EndingDateTime DATETIME2(7) NULL DEFAULT (SYSDATETIME())
			,ClassTime CHAR(5) NULL DEFAULT ('09:15')
			,lastName varchar(30) null default 'Khodjayev' -- individual table
		    ,firstName varchar(30) null default 'Dilshod' -- individual table
			,GroupName varchar(30) NULL DEFAULT ('group #2') -- for the group
		  );
use BIClass;
go
drop table if exists Process.usp_TrackWorkFlow
create table Process.usp_TrackWorkFlow
				 (startTime datetime2
				  ,WorkFlowDescription varchar(max)
				  ,WorkFlowStepTableRowCount varchar(max)
				  );
go
use BIClass;
go
/****** Object:  StoredProcedure [Project1].[DropForeignKeysFromStarSchemaData]    Script Date: 11/12/2018 7:36:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
if OBJECT_ID('[Project1].[DropForeignKeysFromStarSchemaData]','p') is not null
drop proc [Project1].[DropForeignKeysFromStarSchemaData];
go
-- =============================================
-- Author:		<Dilshod,Khodjayev>
-- Create date: <11/12/2018>
-- Description:	<remove all the foreign keys from all tables>
-- =============================================

create PROCEDURE [Project1].[DropForeignKeysFromStarSchemaData]
AS
BEGIN
     SET NOCOUNT ON;
	alter table [CH01-01-Fact].Data drop constraint if exists FK_Data_DimOccupation;
 	alter table [CH01-01-Fact].Data drop constraint if exists FK_Data_DimTerritory;
	alter table [CH01-01-Fact].Data drop constraint if exists FK_Data_DimProduct;
	alter table [CH01-01-Fact].Data drop constraint if exists FK_Data_DimCustomer;
	alter table [CH01-01-Fact].Data drop constraint if exists FK_Data_DimOrderDate;
	alter table [CH01-01-Fact].Data drop constraint if exists FK_Data_DimMaritalStatus;
	alter table [CH01-01-Fact].Data drop constraint if exists FK_Data_DimGender;
	
	alter table [CH01-01-Dimension].[DimProductSubcategory] drop constraint if exists  [FK_DimProductSubcategory_DimProductCategory];
	
	alter table [CH01-01-Dimension].[DimProduct] drop constraint if exists [FK_DimProduct_DimProductSubcategory];
	
	 exec [Process].[removeConstraint] 'DimTerritory','classtime','class';
	 exec [Process].[removeConstraint] 'DimTerritory','LastName','Last';
	 exec [Process].[removeConstraint] 'DimTerritory','FirstName','First';
	 exec [Process].[removeConstraint] 'DimTerritory','DateAdded','Date';

	alter table [CH01-01-Dimension].[DimTerritory] drop column if exists classTime;
	alter table [CH01-01-Dimension].[DimTerritory] drop column if exists LastName;
	alter table [CH01-01-Dimension].[DimTerritory] drop column if exists FirstName;
	alter table [CH01-01-Dimension].[DimTerritory] drop column if exists DateAdded;

	--hanjin constrains




	--antorny's constrains


END;
go
GO
-- =============================================
-- Author:		<Dilshod khodjayev>
-- Create date: <11/16/2018>
-- Description:	<add all data back to the table>
-- =============================================
if OBJECT_ID('[Process].[populateDimTerrritory]','p') is not null
	drop proc [Process].[populateDimTerrritory];
go
create PROCEDURE [Process].[populateDimTerrritory]
AS
BEGIN
	declare @description varchar(max) = 'remove data, remove constr, add new columns, populate table';
	declare @start datetime2 = sysdatetime();
	
	INSERT INTO [CH01-01-Dimension].DimTerritory
	(
       [TerritoryGroup]
      ,[TerritoryCountry]
      ,[TerritoryRegion]
 
	)
	SELECT
       [TerritoryGroup]
      ,[TerritoryCountry]
      ,[TerritoryRegion]
	 
	FROM FileUpload.OriginallyLoadedData 
	
	 declare @rowC int
	 select @rowC = COUNT(*) from [CH01-01-Dimension].DimTerritory;

	 exec [Process].[TrackWorkFlow] @start, @description, @rowC
 	 select * from Process.WorkflowSteps
END
go
if OBJECT_ID('[Project1].[AddForeignKeysToStarSchemaData]','p') is not null
	drop proc [Project1].[AddForeignKeysToStarSchemaData];
GO
/****** Object:  StoredProcedure [Project1].[AddForeignKeysToStarSchemaData]    Script Date: 11/12/2018 9:34:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dilshod,Khodjayev>
-- Create date: <11/12/2018>
-- Description:	<add proper foreign keys into all tables>
-- =============================================
create PROCEDURE [Project1].[AddForeignKeysToStarSchemaData]

AS
BEGIN
     -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
	alter table [CH01-01-Fact].Data add constraint FK_Data_DimOccupation foreign key([OccupationKey]) references [CH01-01-Dimension].[DimOccupation]([OccupationKey]);
	alter table [CH01-01-Fact].Data add constraint FK_Data_DimTerritory foreign key([TerritoryKey]) references  [CH01-01-Dimension].[DimTerritory]([TerritoryKey]);
	alter table [CH01-01-Fact].Data add constraint  FK_Data_DimProduct foreign key([ProductKey]) references [CH01-01-Dimension].[DimProduct]([ProductKey]);
	alter table [CH01-01-Fact].Data add constraint  FK_Data_DimCustomer foreign key([CustomerKey]) references [CH01-01-Dimension].[DimCustomer]([CustomerKey]);
	alter table [CH01-01-Fact].Data add constraint FK_Data_DimOrderDate foreign key([OrderDate]) references [CH01-01-Dimension].[DimOrderDate]([OrderDate]);
	alter table [CH01-01-Fact].Data add constraint FK_Data_DimMaritalStatus foreign key([MaritalStatus]) references [CH01-01-Dimension].[DimMaritalStatus]([MaritalStatus]);
	alter table [CH01-01-Fact].Data add constraint FK_Data_DimGender foreign key([Gender]) references [CH01-01-Dimension].[DimGender]([Gender]);
	
	alter table[CH01-01-Dimension].[DimProductSubcategory] add constraint  [FK_DimProductSubcategory_DimProductCategory] foreign key([ProductCategoryKey]) references [CH01-01-Dimension].[DimProductCategory]([ProductCategoryKey]);

	alter table [CH01-01-Dimension].[DimProduct]  add constraint [FK_DimProduct_DimProductSubcategory] foreign key([ProductSubcategoryKey]) references [CH01-01-Dimension].[DimProductSubcategory]([ProductSubcategoryKey]);
	
	exec process.populateDimTerrritory;

END;

GO
/****** Object:  StoredProcedure [Project1].[TruncateStarSchemaData]    Script Date: 11/13/2018 12:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if OBJECT_ID('[Project1].[TruncateStarSchemaData]','p') is not null
	drop proc [Project1].[TruncateStarSchemaData];
go
-- =============================================
-- Author:		<Dilshod,Khodjayev>
-- Create date: <11/12/2018>
-- Description:	<remove all data from all tables>
-- =============================================
create PROCEDURE [Project1].[TruncateStarSchemaData]
AS
BEGIN
 
	SET NOCOUNT ON;
	--something in this table
	truncate table [CH01-01-Fact].Data; --first turnicate
	truncate table [CH01-01-Dimension].[DimOccupation];
	truncate table [CH01-01-Dimension].[DimOrderDate];
	truncate table [CH01-01-Dimension].[DimProduct];
	truncate table [CH01-01-Dimension].[DimProductCategory];
	truncate table [CH01-01-Dimension].[DimProductSubcategory];
	truncate table [CH01-01-Dimension].[DimTerritory];
 	truncate table [CH01-01-Dimension].[DimCustomer];
	truncate table [CH01-01-Dimension].[DimGender];
	truncate table [CH01-01-Dimension].[DimMaritalStatus];
	truncate table [CH01-01-Dimension].[SalesManagers];
end

go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dilshod khodjayev>
-- Create date: <11/13/2019>
-- Description:	<process.TrackWorkFlow>
-- =============================================
if OBJECT_ID('process.TrackWorkFlow','p') is not null
drop proc process.TrackWorkFlow;
go
CREATE PROCEDURE process.TrackWorkFlow
	@StartTime DATETIME, 
	@WorkFlowDescription NVARCHAR(100),
	@WorkFlowStepTableRowCount int
as
BEGIN
	insert into Process.WorkflowSteps 
		(  [DateAdded]
		  ,[WorkFlowStepDescription]
		  ,[WorkFlowStepTableRowCount]
		
		 )
	    values
		 (
		  @StartTime
		 ,@WorkFlowDescription
		 ,@WorkFlowStepTableRowCount
		 );
		 --,'20181112 16:56:50.1364677','20181113 16:56:50.1364677'
END
--/////////////////////////////////////////////////////////////////////////////////////////////////
GO
/****** Object:  StoredProcedure [Process].[removeConstraint]    Script Date: 11/21/2018 12:40:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Dilshod Khodjayev>
-- Create date: <11/18/2018>
-- Description:	<remove new column default constraint>
-- =============================================
if OBJECT_ID('[Process].[removeConstraint]','p') is not null
	drop proc [Process].[removeConstraint];
go
create proc [Process].[removeConstraint](
	@table varchar(max),
	@colName varchar(max),
	@constrKeyPhrase varchar(max))
 AS
BEGIN
 declare @constr as varchar(max) = 'none'
	select @constr = SysDConstr.name  
	from sys.all_columns as SysAllCols inner join
		 sys.tables as SysTable 
			on SysTable.object_id = SysAllCols.object_id inner join
		 sys.default_constraints as SysDConstr on SysDConstr.parent_object_id = SysTable.object_id	
	where SysAllCols.name = @colName and SysTable.name = @table and SysDConstr.name like +'%'+ @constrKeyPhrase+'%'
 
 	declare @result as varchar(max) = 'false'

	if @constr not like 'none'
	begin
		declare @fullTableName as varchar(max) = '[CH01-01-Dimension].'+@table;
		declare @query as varchar(max) = 'alter table '+@fullTableName+' drop constraint '+@constr;
		execute(@query);
	--	select 'deleted'
	end	
END
go
USE [BIClass]
GO
/****** Object:  StoredProcedure [Process].[populateDimTerrritory]    Script Date: 11/21/2018 2:39:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON

go
--///////////////////////////////////////////////////////////////////////////////////////
if OBJECT_ID('[Project1].[Load_DimTerritory]','p') is not null
	drop proc [Project1].[Load_DimTerritory];
go
create PROCEDURE [Project1].[Load_DimTerritory]
AS
BEGIN
	SET NOCOUNT ON;
 
	 exec [Process].[removeConstraint] 'DimTerritory','classtime','class';
	 exec [Process].[removeConstraint] 'DimTerritory','LastName','Last';
	 exec [Process].[removeConstraint] 'DimTerritory','FirstName','First';
	 exec [Process].[removeConstraint] 'DimTerritory','DateAdded','Date';
	
	alter table [CH01-01-Dimension].[DimTerritory] drop column if exists classTime;
	alter table [CH01-01-Dimension].[DimTerritory] drop column if exists LastName;
	alter table [CH01-01-Dimension].[DimTerritory] drop column if exists FirstName;
	alter table [CH01-01-Dimension].[DimTerritory] drop column if exists DateAdded;

	alter table [CH01-01-Dimension].[DimTerritory] add classTime varchar(5)  null default '09:15';
	alter table [CH01-01-Dimension].[DimTerritory] add LastName  varchar(30) null default 'Khodjayev';
	alter table [CH01-01-Dimension].[DimTerritory] add FirstName   varchar(30) null default 'Dilshod';
	alter table [CH01-01-Dimension].[DimTerritory] add DateAdded datetime2 null default sysdatetime();

END

--//////////////////////////////////////////////////////////////////////////////////////////////////
go
USE [BIClass]
GO
/****** Object:  StoredProcedure [Process].[TrackWorkFlow]    Script Date: 11/21/2018 2:06:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
if OBJECT_ID('[Process].[TrackWorkFlow]','p') is not null
drop proc [Process].[TrackWorkFlow];
go
create PROCEDURE [Process].[TrackWorkFlow]
	@StartTime DATETIME, 
	@WorkFlowDescription NVARCHAR(100),
	@WorkFlowStepTableRowCount int
as
BEGIN
	insert into Process.WorkflowSteps 
		(  [DateAdded]
		  ,[WorkFlowStepDescription]
		  ,[WorkFlowStepTableRowCount]
		 )
	    values
		 (
		  @StartTime
		 ,@WorkFlowDescription
		 ,@WorkFlowStepTableRowCount
		 );
END

 --dwadwadwadwadfwadfwadawdwa
--dwadawdwadawdwadwad
---wdadwadawdwadwad
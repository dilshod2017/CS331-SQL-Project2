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


		--/////////////////////////////////////////////////////////////
		--truncate table [CH01-01-Fact].Data; --first turnicate
		--alter table [CH01-01-Fact].Data add classTime varchar(5) default '0900-1045',
		--                                    LastName varchar(30) DEFAULT ('Dilshod'),
		--									FirstName varchar(30) DEFAULT ('Khodjayev'),
		--									DateAdded datetime2 default sysdatetime();
			
		--/////////////////////////////////////////////////////////////
		--exec [Project1].[DropForeignKeysFromStarSchemaData]
		--exec [Project1].[TruncateStarSchemaData]




GO
/****** Object:  StoredProcedure [Project1].[DropForeignKeysFromStarSchemaData]    Script Date: 11/12/2018 7:36:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
if OBJECT_ID('[Project1].[DropForeignKeysFromStarSchemaData]','p') is not null
drop proc [Project1].[DropForeignKeysFromStarSchemaData];
go
create PROCEDURE [Project1].[DropForeignKeysFromStarSchemaData]
AS
BEGIN
    SET NOCOUNT ON;
		/* FK_Data_SalesManagers
		FK_Data_DimOccupation
		FK_Data_DimTerritory
		FK_Data_DimProduct
		FK_Data_DimCustomer
		FK_Data_DimOrderDate
		FK_Data_DimMaritalStatus
		FK_Data_DimGender
		*/
		--this is test
	alter table [CH01-01-Fact].Data drop constraint if exists FK_Data_DimOccupation;
 	alter table [CH01-01-Fact].Data drop constraint if exists FK_Data_DimTerritory;
	alter table [CH01-01-Fact].Data drop constraint if exists FK_Data_DimProduct;
	alter table [CH01-01-Fact].Data drop constraint if exists FK_Data_DimCustomer;
	alter table [CH01-01-Fact].Data drop constraint if exists FK_Data_DimOrderDate;
	alter table [CH01-01-Fact].Data drop constraint if exists FK_Data_DimMaritalStatus;
	alter table [CH01-01-Fact].Data drop constraint if exists FK_Data_DimGender;
	alter table [CH01-01-Dimension].[DimProductSubcategory] drop constraint if exists [FK_DimProductSubcategory_DimProductCategory];
	alter table [CH01-01-Dimension].[DimProduct] drop constraint if exists [FK_DimProduct_DimProductSubcategory];



	--truncate table [CH01-01-Fact].Data; --first turnicate
	--truncate table [CH01-01-Dimension].[DimOccupation]
	--truncate table [CH01-01-Dimension].[DimOrderDate]
	--truncate table [CH01-01-Dimension].[DimProduct]
	--truncate table [CH01-01-Dimension].[DimProductCategory]
	--truncate table [CH01-01-Dimension].[DimProductSubcategory]
	--truncate table [CH01-01-Dimension].[DimTerritory]
	--truncate table [CH01-01-Dimension].[SalesManagers]
	--truncate table [CH01-01-Dimension].[DimCustomer];
	--truncate table [CH01-01-Dimension].[DimGender];
	--truncate table [CH01-01-Dimension].[DimMaritalStatus]

END;



GO
/****** Object:  StoredProcedure [Project1].[Load_SalesManagers]    Script Date: 11/12/2018 8:32:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		YourName
-- Create date: 
-- Description:	
-- =============================================

if OBJECT_ID('[Project1].[Load_SalesManagers] ','p') is not null
	drop proc [Project1].[Load_SalesManagers] ;
go

create PROCEDURE [Project1].[Load_SalesManagers] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	INSERT INTO [CH01-01-Dimension].SalesManagers
	(
		SalesManagerKey,
		Category,
		SalesManager,
		Office
	)
	SELECT DISTINCT
		SalesManagerKey,
		old.ProductCategory,
		SalesManager,
		Office = CASE
					 WHEN old.SalesManager LIKE 'Marco%' THEN
						 'Redmond'
					 WHEN old.SalesManager LIKE 'Alberto%' THEN
						 'Seattle'
					 WHEN old.SalesManager LIKE 'Maurizio%' THEN
						 'Redmond'
					 ELSE
						 'Seattle'
				 END
	FROM FileUpload.OriginallyLoadedData AS old
	ORDER BY old.SalesManagerKey;
END

go

if OBJECT_ID('[Project1].[AddForeignKeysToStarSchemaData]','p') is not null
	drop proc [Project1].[AddForeignKeysToStarSchemaData];
go

GO
/****** Object:  StoredProcedure [Project1].[AddForeignKeysToStarSchemaData]    Script Date: 11/12/2018 9:34:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
	--alter table [CH01-01-Fact].Data add constraint [FK_DimProduct_DimProductSubcategory] foreign key([ProductSubcategory]) references [CH01-01-Dimension].[DimProductCategory]([ProductCategoryKey]);

	
 	--alter table [CH01-01-Fact].Data add constraint foreign key() references ()
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


create PROCEDURE [Project1].[TruncateStarSchemaData]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--something in this table
	truncate table [CH01-01-Fact].Data; --first turnicate
	truncate table [CH01-01-Dimension].[DimOccupation];
	truncate table [CH01-01-Dimension].[DimOrderDate];
	truncate table [CH01-01-Dimension].[DimProduct];
	truncate table [CH01-01-Dimension].[DimProductCategory];
	truncate table [CH01-01-Dimension].[DimProductSubcategory];
	truncate table [CH01-01-Dimension].[DimTerritory];
	truncate table [CH01-01-Dimension].[SalesManagers];
	truncate table [CH01-01-Dimension].[DimCustomer];
	truncate table [CH01-01-Dimension].[DimGender];
	truncate table [CH01-01-Dimension].[DimMaritalStatus];



end

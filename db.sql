USE [master]
GO
/****** Object:  Database [BIClass]    Script Date: 11/13/2018 10:11:11 AM ******/
CREATE DATABASE [BIClass]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BIClass', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\BIClass.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'BIClass_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\BIClass_0.ldf' , SIZE = 84416KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [BIClass] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BIClass].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BIClass] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BIClass] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BIClass] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BIClass] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BIClass] SET ARITHABORT OFF 
GO
ALTER DATABASE [BIClass] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BIClass] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BIClass] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BIClass] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BIClass] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BIClass] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BIClass] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BIClass] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BIClass] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BIClass] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BIClass] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BIClass] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BIClass] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BIClass] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BIClass] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BIClass] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BIClass] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BIClass] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [BIClass] SET  MULTI_USER 
GO
ALTER DATABASE [BIClass] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BIClass] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BIClass] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BIClass] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [BIClass] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BIClass] SET QUERY_STORE = OFF
GO
USE [BIClass]
GO
/****** Object:  User [rheller]    Script Date: 11/13/2018 10:11:11 AM ******/
CREATE USER [rheller] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [OCCAM\pheller]    Script Date: 11/13/2018 10:11:11 AM ******/
CREATE USER [OCCAM\pheller] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [EC3\thehitman]    Script Date: 11/13/2018 10:11:11 AM ******/
CREATE USER [EC3\thehitman] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [dbuser]    Script Date: 11/13/2018 10:11:11 AM ******/
CREATE USER [dbuser] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [rheller]
GO
ALTER ROLE [db_owner] ADD MEMBER [OCCAM\pheller]
GO
ALTER ROLE [db_owner] ADD MEMBER [EC3\thehitman]
GO
ALTER ROLE [db_datareader] ADD MEMBER [dbuser]
GO
/****** Object:  Schema [CH01-01-Dimension]    Script Date: 11/13/2018 10:11:11 AM ******/
CREATE SCHEMA [CH01-01-Dimension]
GO
/****** Object:  Schema [CH01-01-Fact]    Script Date: 11/13/2018 10:11:11 AM ******/
CREATE SCHEMA [CH01-01-Fact]
GO
/****** Object:  Schema [FileUpload]    Script Date: 11/13/2018 10:11:11 AM ******/
CREATE SCHEMA [FileUpload]
GO
/****** Object:  Schema [Process]    Script Date: 11/13/2018 10:11:11 AM ******/
CREATE SCHEMA [Process]
GO
/****** Object:  Schema [Project1]    Script Date: 11/13/2018 10:11:11 AM ******/
CREATE SCHEMA [Project1]
GO
/****** Object:  Schema [Utils]    Script Date: 11/13/2018 10:11:11 AM ******/
CREATE SCHEMA [Utils]
GO
/****** Object:  UserDefinedFunction [dbo].[Multiplyby10]    Script Date: 11/13/2018 10:11:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		YourName
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[Multiplyby10] 
(
	-- Add the parameters for the function here
	@AInteger int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here

	-- Return the result of the function
	RETURN @AInteger*10

END
GO
/****** Object:  View [Utils].[uvw_FindColumnDefinitionPlusDefaultAndCheckConstraint]    Script Date: 11/13/2018 10:11:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--create schema Utils;

CREATE VIEW [Utils].[uvw_FindColumnDefinitionPlusDefaultAndCheckConstraint] AS
SELECT  CONCAT(tbl.TABLE_SCHEMA, '.', tbl.TABLE_NAME) AS FullyQualifiedTableName ,
        tbl.TABLE_SCHEMA AS SchemaName ,
        tbl.TABLE_NAME AS TableName ,
        col.COLUMN_NAME AS ColumnName ,
        col.ORDINAL_POSITION AS OrdinalPosition,
        CONCAT(col.DOMAIN_SCHEMA, '.', col.DOMAIN_NAME) AS FullyQualifiedDomainName ,
        col.DOMAIN_NAME AS DomainName ,
        CASE
                      WHEN col.DATA_TYPE = 'char'
             THEN CONCAT('char(', CHARACTER_MAXIMUM_LENGTH, ')')
                     WHEN col.DATA_TYPE = 'nchar'
             THEN CONCAT('nchar(', CHARACTER_MAXIMUM_LENGTH, ')')
                     WHEN col.DATA_TYPE = 'Nvarchar'
             THEN CONCAT('nvarchar(', CHARACTER_MAXIMUM_LENGTH, ')')
                     WHEN col.DATA_TYPE = 'varchar'
             THEN CONCAT('varchar(', CHARACTER_MAXIMUM_LENGTH, ')')
             WHEN col.DATA_TYPE = 'numeric'
             THEN CONCAT('numeric(', NUMERIC_PRECISION, ', ',
                         NUMERIC_SCALE, ')')
             WHEN col.DATA_TYPE = 'decimal'
             THEN CONCAT('decimal(', NUMERIC_PRECISION, ', ',
                         NUMERIC_SCALE, ')')
             ELSE col.DATA_TYPE
        END AS DataType ,
        col.IS_NULLABLE AS IsNullable,
        dcn.DefaultName ,
        col.COLUMN_DEFAULT AS DefaultNameDefinition ,
        cc.CONSTRAINT_NAME AS CheckConstraintRuleName,
        cc.CHECK_CLAUSE  AS CheckConstraintRuleNameDefinition
FROM    ( SELECT    TABLE_CATALOG ,
                    TABLE_SCHEMA ,
                    TABLE_NAME ,
                    TABLE_TYPE
          FROM      INFORMATION_SCHEMA.TABLES
        ) AS tbl
        INNER JOIN ( SELECT TABLE_CATALOG ,
                            TABLE_SCHEMA ,
                            TABLE_NAME ,
                            COLUMN_NAME ,
                            ORDINAL_POSITION ,
                            COLUMN_DEFAULT ,
                            IS_NULLABLE ,
                            DATA_TYPE ,
                            CHARACTER_MAXIMUM_LENGTH ,
                            CHARACTER_OCTET_LENGTH ,
                            NUMERIC_PRECISION ,
                            NUMERIC_PRECISION_RADIX ,
                            NUMERIC_SCALE ,
                            DATETIME_PRECISION ,
                            CHARACTER_SET_CATALOG ,
                            CHARACTER_SET_SCHEMA ,
                            CHARACTER_SET_NAME ,
                            COLLATION_CATALOG ,
                            COLLATION_SCHEMA ,
                            COLLATION_NAME ,
                            DOMAIN_CATALOG ,
                            DOMAIN_SCHEMA ,
                            DOMAIN_NAME
                     FROM   INFORMATION_SCHEMA.COLUMNS
                   ) AS col ON col.TABLE_CATALOG = tbl.TABLE_CATALOG
                               AND col.TABLE_SCHEMA = tbl.TABLE_SCHEMA
                               AND col.TABLE_NAME = tbl.TABLE_NAME
        LEFT OUTER JOIN ( SELECT    t.name AS TableName ,
                                    SCHEMA_NAME(s.schema_id) AS SchemaName ,
                                    ac.name AS ColumnName ,
                                    d.name AS DefaultName
                          FROM      sys.all_columns AS ac
                                    INNER JOIN sys.tables AS t ON ac.object_id = t.object_id
                                    INNER JOIN sys.schemas AS s ON t.schema_id = s.schema_id
                                    INNER JOIN sys.default_constraints AS d ON ac.default_object_id = d.object_id
                        ) AS dcn ON dcn.SchemaName = tbl.TABLE_SCHEMA
                                    AND dcn.TableName = tbl.TABLE_NAME
                                    AND dcn.ColumnName = col.COLUMN_NAME
        LEFT OUTER JOIN ( SELECT    cu.TABLE_CATALOG ,
                                    cu.TABLE_SCHEMA ,
                                    cu.TABLE_NAME ,
                                    cu.COLUMN_NAME ,
                                    c.CONSTRAINT_CATALOG ,
                                    c.CONSTRAINT_SCHEMA ,
                                    c.CONSTRAINT_NAME ,
                                    c.CHECK_CLAUSE
                          FROM      INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE
                                    AS cu
                                    INNER JOIN INFORMATION_SCHEMA.CHECK_CONSTRAINTS
                                    AS c ON c.CONSTRAINT_NAME = cu.CONSTRAINT_NAME
                        ) AS cc ON cc.TABLE_SCHEMA = tbl.TABLE_SCHEMA
                                   AND cc.TABLE_NAME = tbl.TABLE_NAME
                                   AND cc.COLUMN_NAME = col.COLUMN_NAME
 
 
GO
/****** Object:  View [Utils].[uvw_FindTablesStorageBytes]    Script Date: 11/13/2018 10:11:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [Utils].[uvw_FindTablesStorageBytes] as 
select FullyQualifiedTableName
     , ColumnName
     , DataType
     , OrdinalPosition
     , StorageBytes = case
                          when charindex('(', DataType, 0) > 0
                               and substring(DataType, 1, 3) = 'var' then
                              cast(substring(
                                                DataType
                                              , charindex('(', DataType, 0) + 1
                                              , len(DataType) - charindex('(', DataType, 0) - 1
                                            ) as int) + 2
                          when charindex('(', DataType, 0) > 0
                               and substring(DataType, 1, 3) = 'cha' then
                              cast(substring(
                                                DataType
                                              , charindex('(', DataType, 0) + 1
                                              , len(DataType) - charindex('(', DataType, 0) - 1
                                            ) as int)
                          when substring(DataType, 1, 3) = 'int' then
                              4
                          when substring(DataType, 1, 3) = 'mon' then
                              4
                          when substring(DataType, 1, 3) = 'dat' then
                              3
                          else
                              -999
                      end
from Utils.uvw_FindColumnDefinitionPlusDefaultAndCheckConstraint
where (SchemaName like 'CH%');
GO
/****** Object:  View [Utils].[ShowServerUserNameAndCurrentDatabase]    Script Date: 11/13/2018 10:11:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [Utils].[ShowServerUserNameAndCurrentDatabase]
as
       select  ServerName= @@SERVERNAME
       ,       YourUserName =  system_user
       ,       CurrentDatabase =  db_name();  
 
GO
/****** Object:  Table [CH01-01-Dimension].[DimCustomer]    Script Date: 11/13/2018 10:11:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CH01-01-Dimension].[DimCustomer](
	[CustomerKey] [int] IDENTITY(1,1) NOT NULL,
	[CustomerName] [varchar](30) NULL,
 CONSTRAINT [PK__DimCusto__95011E6452BCF41C] PRIMARY KEY CLUSTERED 
(
	[CustomerKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CH01-01-Dimension].[DimGender]    Script Date: 11/13/2018 10:11:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CH01-01-Dimension].[DimGender](
	[Gender] [char](1) NOT NULL,
	[GenderDescription] [varchar](6) NOT NULL,
 CONSTRAINT [PK_DimGender] PRIMARY KEY CLUSTERED 
(
	[Gender] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CH01-01-Dimension].[DimMaritalStatus]    Script Date: 11/13/2018 10:11:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CH01-01-Dimension].[DimMaritalStatus](
	[MaritalStatus] [char](1) NOT NULL,
	[MaritalStatusDescription] [varchar](7) NOT NULL,
 CONSTRAINT [PK_DimMaritalStatus] PRIMARY KEY CLUSTERED 
(
	[MaritalStatus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CH01-01-Dimension].[DimOccupation]    Script Date: 11/13/2018 10:11:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CH01-01-Dimension].[DimOccupation](
	[OccupationKey] [int] NOT NULL,
	[Occupation] [varchar](20) NULL,
 CONSTRAINT [PK_DimOccupation] PRIMARY KEY CLUSTERED 
(
	[OccupationKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CH01-01-Dimension].[DimOrderDate]    Script Date: 11/13/2018 10:11:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CH01-01-Dimension].[DimOrderDate](
	[OrderDate] [date] NOT NULL,
	[MonthName] [varchar](10) NULL,
	[MonthNumber] [int] NULL,
	[Year] [int] NULL,
 CONSTRAINT [PK_DimOrderDate_1] PRIMARY KEY CLUSTERED 
(
	[OrderDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CH01-01-Dimension].[DimProduct]    Script Date: 11/13/2018 10:11:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CH01-01-Dimension].[DimProduct](
	[ProductKey] [int] IDENTITY(1,1) NOT NULL,
	[ProductSubcategoryKey] [int] NULL,
	[ProductCategory] [varchar](20) NULL,
	[ProductSubcategory] [varchar](20) NULL,
	[ProductCode] [varchar](10) NULL,
	[ProductName] [varchar](40) NULL,
	[Color] [varchar](10) NULL,
	[ModelName] [varchar](30) NULL,
 CONSTRAINT [PK__DimProdu__A15E99B3E27177EF] PRIMARY KEY CLUSTERED 
(
	[ProductKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CH01-01-Dimension].[DimProductCategory]    Script Date: 11/13/2018 10:11:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CH01-01-Dimension].[DimProductCategory](
	[ProductCategoryKey] [int] IDENTITY(1,1) NOT NULL,
	[ProductCategory] [varchar](20) NULL,
 CONSTRAINT [PK_DimProductCategory] PRIMARY KEY CLUSTERED 
(
	[ProductCategoryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CH01-01-Dimension].[DimProductSubcategory]    Script Date: 11/13/2018 10:11:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CH01-01-Dimension].[DimProductSubcategory](
	[ProductSubcategoryKey] [int] IDENTITY(1,1) NOT NULL,
	[ProductCategoryKey] [int] NULL,
	[ProductSubcategory] [varchar](20) NULL,
 CONSTRAINT [PK_DimProductSubcategory] PRIMARY KEY CLUSTERED 
(
	[ProductSubcategoryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CH01-01-Dimension].[DimTerritory]    Script Date: 11/13/2018 10:11:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CH01-01-Dimension].[DimTerritory](
	[TerritoryKey] [int] IDENTITY(1,1) NOT NULL,
	[TerritoryGroup] [varchar](20) NULL,
	[TerritoryCountry] [varchar](20) NULL,
	[TerritoryRegion] [varchar](20) NULL,
 CONSTRAINT [PK__DimTerri__C54B735D813BBCA6] PRIMARY KEY CLUSTERED 
(
	[TerritoryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CH01-01-Dimension].[SalesManagers]    Script Date: 11/13/2018 10:11:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CH01-01-Dimension].[SalesManagers](
	[SalesManagerKey] [int] NOT NULL,
	[Category] [varchar](20) NULL,
	[SalesManager] [varchar](50) NULL,
	[Office] [varchar](50) NULL,
 CONSTRAINT [PK_SalesManagers] PRIMARY KEY CLUSTERED 
(
	[SalesManagerKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [CH01-01-Fact].[Data]    Script Date: 11/13/2018 10:11:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CH01-01-Fact].[Data](
	[SalesKey] [int] IDENTITY(1,1) NOT NULL,
	[SalesManagerKey] [int] NULL,
	[OccupationKey] [int] NULL,
	[TerritoryKey] [int] NULL,
	[ProductKey] [int] NULL,
	[CustomerKey] [int] NULL,
	[ProductCategory] [varchar](20) NULL,
	[SalesManager] [varchar](20) NULL,
	[ProductSubcategory] [varchar](20) NULL,
	[ProductCode] [varchar](10) NULL,
	[ProductName] [varchar](40) NULL,
	[Color] [varchar](10) NULL,
	[ModelName] [varchar](30) NULL,
	[OrderQuantity] [int] NULL,
	[UnitPrice] [money] NULL,
	[ProductStandardCost] [money] NULL,
	[SalesAmount] [money] NULL,
	[OrderDate] [date] NULL,
	[MonthName] [varchar](10) NULL,
	[MonthNumber] [int] NULL,
	[Year] [int] NULL,
	[CustomerName] [varchar](30) NULL,
	[MaritalStatus] [char](1) NULL,
	[Gender] [char](1) NULL,
	[Education] [varchar](20) NULL,
	[Occupation] [varchar](20) NULL,
	[TerritoryRegion] [varchar](20) NULL,
	[TerritoryCountry] [varchar](20) NULL,
	[TerritoryGroup] [varchar](20) NULL,
 CONSTRAINT [PK_Data] PRIMARY KEY CLUSTERED 
(
	[SalesKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tempTable]    Script Date: 11/13/2018 10:11:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tempTable](
	[SalesKey] [int] IDENTITY(1,1) NOT NULL,
	[SalesManagerKey] [int] NULL,
	[OccupationKey] [int] NULL,
	[TerritoryKey] [int] NULL,
	[ProductKey] [int] NULL,
	[CustomerKey] [int] NULL,
	[ProductCategory] [varchar](20) NULL,
	[SalesManager] [varchar](20) NULL,
	[ProductSubcategory] [varchar](20) NULL,
	[ProductCode] [varchar](10) NULL,
	[ProductName] [varchar](40) NULL,
	[Color] [varchar](10) NULL,
	[ModelName] [varchar](30) NULL,
	[OrderQuantity] [int] NULL,
	[UnitPrice] [money] NULL,
	[ProductStandardCost] [money] NULL,
	[SalesAmount] [money] NULL,
	[OrderDate] [date] NULL,
	[MonthName] [varchar](10) NULL,
	[MonthNumber] [int] NULL,
	[Year] [int] NULL,
	[CustomerName] [varchar](30) NULL,
	[MaritalStatus] [char](1) NULL,
	[Gender] [char](1) NULL,
	[Education] [varchar](20) NULL,
	[Occupation] [varchar](20) NULL,
	[TerritoryRegion] [varchar](20) NULL,
	[TerritoryCountry] [varchar](20) NULL,
	[TerritoryGroup] [varchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Variant]    Script Date: 11/13/2018 10:11:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Variant](
	[key] [int] IDENTITY(1,1) NOT NULL,
	[col] [sql_variant] NULL,
 CONSTRAINT [PK_Variant] PRIMARY KEY CLUSTERED 
(
	[key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [FileUpload].[OriginallyLoadedData]    Script Date: 11/13/2018 10:11:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FileUpload].[OriginallyLoadedData](
	[SalesKey] [int] NOT NULL,
	[SalesManagerKey] [int] NULL,
	[OccupationKey] [int] NULL,
	[ProductCategory] [varchar](20) NULL,
	[SalesManager] [varchar](20) NULL,
	[ProductSubcategory] [varchar](20) NULL,
	[ProductCode] [varchar](10) NULL,
	[ProductName] [varchar](40) NULL,
	[Color] [varchar](10) NULL,
	[ModelName] [varchar](30) NULL,
	[OrderQuantity] [int] NULL,
	[UnitPrice] [money] NULL,
	[ProductStandardCost] [money] NULL,
	[SalesAmount] [money] NULL,
	[OrderDate] [date] NULL,
	[MonthName] [varchar](10) NULL,
	[MonthNumber] [int] NULL,
	[Year] [int] NULL,
	[CustomerName] [varchar](30) NULL,
	[MaritalStatus] [char](1) NULL,
	[Gender] [char](1) NULL,
	[Education] [varchar](20) NULL,
	[Occupation] [varchar](20) NULL,
	[TerritoryRegion] [varchar](20) NULL,
	[TerritoryCountry] [varchar](20) NULL,
	[TerritoryGroup] [varchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Process].[WorkflowSteps]    Script Date: 11/13/2018 10:11:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Process].[WorkflowSteps](
	[WorkFlowStepKey] [int] IDENTITY(1,1) NOT NULL,
	[DateAdded] [datetime2](7) NOT NULL,
	[WorkFlowStepDescription] [nvarchar](100) NOT NULL,
	[WorkFlowStepTableRowCount] [int] NULL,
	[StartingDateTime] [datetime2](7) NULL,
	[EndingDateTime] [datetime2](7) NULL,
	[ClassTime] [char](5) NULL,
	[lastName] [varchar](30) NOT NULL,
	[firstName] [varchar](30) NOT NULL,
	[GroupName] [varchar](30) NULL
) ON [PRIMARY]
GO
ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT (sysdatetime()) FOR [DateAdded]
GO
ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT ((0)) FOR [WorkFlowStepTableRowCount]
GO
ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT (sysdatetime()) FOR [StartingDateTime]
GO
ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT (sysdatetime()) FOR [EndingDateTime]
GO
ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT ('09:15') FOR [ClassTime]
GO
ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT ('Khodjayev') FOR [lastName]
GO
ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT ('Dilshod') FOR [firstName]
GO
ALTER TABLE [Process].[WorkflowSteps] ADD  DEFAULT ('group #2') FOR [GroupName]
GO
ALTER TABLE [CH01-01-Dimension].[DimProductSubcategory]  WITH CHECK ADD  CONSTRAINT [FK_DimProductSubcategory_DimProductCategory] FOREIGN KEY([ProductCategoryKey])
REFERENCES [CH01-01-Dimension].[DimProductCategory] ([ProductCategoryKey])
GO
ALTER TABLE [CH01-01-Dimension].[DimProductSubcategory] CHECK CONSTRAINT [FK_DimProductSubcategory_DimProductCategory]
GO
ALTER TABLE [CH01-01-Fact].[Data]  WITH CHECK ADD  CONSTRAINT [FK_Data_DimCustomer] FOREIGN KEY([CustomerKey])
REFERENCES [CH01-01-Dimension].[DimCustomer] ([CustomerKey])
GO
ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [FK_Data_DimCustomer]
GO
ALTER TABLE [CH01-01-Fact].[Data]  WITH CHECK ADD  CONSTRAINT [FK_Data_DimGender] FOREIGN KEY([Gender])
REFERENCES [CH01-01-Dimension].[DimGender] ([Gender])
GO
ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [FK_Data_DimGender]
GO
ALTER TABLE [CH01-01-Fact].[Data]  WITH CHECK ADD  CONSTRAINT [FK_Data_DimMaritalStatus] FOREIGN KEY([MaritalStatus])
REFERENCES [CH01-01-Dimension].[DimMaritalStatus] ([MaritalStatus])
GO
ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [FK_Data_DimMaritalStatus]
GO
ALTER TABLE [CH01-01-Fact].[Data]  WITH CHECK ADD  CONSTRAINT [FK_Data_DimOrderDate] FOREIGN KEY([OrderDate])
REFERENCES [CH01-01-Dimension].[DimOrderDate] ([OrderDate])
GO
ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [FK_Data_DimOrderDate]
GO
ALTER TABLE [CH01-01-Fact].[Data]  WITH CHECK ADD  CONSTRAINT [FK_Data_DimProduct] FOREIGN KEY([ProductKey])
REFERENCES [CH01-01-Dimension].[DimProduct] ([ProductKey])
GO
ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [FK_Data_DimProduct]
GO
ALTER TABLE [CH01-01-Fact].[Data]  WITH CHECK ADD  CONSTRAINT [FK_Data_DimTerritory] FOREIGN KEY([TerritoryKey])
REFERENCES [CH01-01-Dimension].[DimTerritory] ([TerritoryKey])
GO
ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [FK_Data_DimTerritory]
GO
/****** Object:  StoredProcedure [dbo].[proc1]    Script Date: 11/13/2018 10:11:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Dilshod Khodjayev
-- Create date: 12.11.2018
-- Description:	project2
-- =============================================
CREATE PROCEDURE [dbo].[proc1]
	@classTime varchar(5),
	@LastName varchar(30),
	@FirstName varchar(30),
	@dateAdded datetime2

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
END
GO
/****** Object:  StoredProcedure [Project1].[AddForeignKeysToStarSchemaData]    Script Date: 11/13/2018 10:11:13 AM ******/
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
/****** Object:  StoredProcedure [Project1].[DropForeignKeysFromStarSchemaData]    Script Date: 11/13/2018 10:11:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [Project1].[Load_Data]    Script Date: 11/13/2018 10:11:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		YourName
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [Project1].[Load_Data]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    /****** Script for SelectTopNRows command from SSMS  ******/
PRINT 'Hi'
END;
GO
/****** Object:  StoredProcedure [Project1].[Load_DimCustomer]    Script Date: 11/13/2018 10:11:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		YourName
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [Project1].[Load_DimCustomer]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
PRINT 'Hi'

END
GO
/****** Object:  StoredProcedure [Project1].[Load_DimGender]    Script Date: 11/13/2018 10:11:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		YourName
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [Project1].[Load_DimGender]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

PRINT 'Hi'
END;
GO
/****** Object:  StoredProcedure [Project1].[Load_DimMaritalStatus]    Script Date: 11/13/2018 10:11:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		YourName
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [Project1].[Load_DimMaritalStatus]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
PRINT 'Hi'

END
GO
/****** Object:  StoredProcedure [Project1].[Load_DimOccupation]    Script Date: 11/13/2018 10:11:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		YourName
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [Project1].[Load_DimOccupation]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
PRINT 'Hi'

END
GO
/****** Object:  StoredProcedure [Project1].[Load_DimOrderDate]    Script Date: 11/13/2018 10:11:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		YourName
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [Project1].[Load_DimOrderDate]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
PRINT 'Hi'

END
GO
/****** Object:  StoredProcedure [Project1].[Load_DimProduct]    Script Date: 11/13/2018 10:11:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		YourName
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [Project1].[Load_DimProduct]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;
PRINT 'Hi'
		   
END
GO
/****** Object:  StoredProcedure [Project1].[Load_DimProductCategory]    Script Date: 11/13/2018 10:11:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		YourName
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [Project1].[Load_DimProductCategory]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

PRINT 'Hi'



END
GO
/****** Object:  StoredProcedure [Project1].[Load_DimProductSubcategory]    Script Date: 11/13/2018 10:11:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		YourName
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [Project1].[Load_DimProductSubcategory]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
 PRINT 'Hi'
END;
GO
/****** Object:  StoredProcedure [Project1].[Load_DimTerritory]    Script Date: 11/13/2018 10:11:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		YourName
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [Project1].[Load_DimTerritory]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
PRINT 'Hi'
	
	END
GO
/****** Object:  StoredProcedure [Project1].[Load_SalesManagers]    Script Date: 11/13/2018 10:11:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		YourName
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [Project1].[Load_SalesManagers] 
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
GO
/****** Object:  StoredProcedure [Project1].[LoadStarSchemaData]    Script Date: 11/13/2018 10:11:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		YourName
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [Project1].[LoadStarSchemaData]
    -- Add the parameters for the stored procedure here
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @return_value INT;
    --
    --	Drop All of the foreign keys prior to truncating tables in the star schema
 	--
    EXEC  [Project1].[DropForeignKeysFromStarSchemaData];
	--
	--	Check row count before truncation
	EXEC	[Project1].[ShowTableStatusRowCount]
		@TableStatus = N'''Pre-truncate of tables'''
    --
    --	Always truncate the Star Schema Data
    --
    EXEC  [Project1].[TruncateStarSchemaData];
    --
    --	Load the star schema
    --
    EXEC  [Project1].[Load_DimProductCategory];
    EXEC  [Project1].[Load_DimProductSubcategory];
    EXEC  [Project1].[Load_DimProduct];
    EXEC  [Project1].[Load_SalesManagers];
    EXEC  [Project1].[Load_DimGender];
    EXEC  [Project1].[Load_DimMaritalStatus];
    EXEC  [Project1].[Load_DimOccupation];
    EXEC  [Project1].[Load_DimOrderDate];
    EXEC  [Project1].[Load_DimTerritory];
    EXEC  [Project1].[Load_DimCustomer];
    EXEC  [Project1].[Load_Data];
  --
    --	Recreate all of the foreign keys prior after loading the star schema
    --
 	--
	--	Check row count before truncation
	EXEC	[Project1].[ShowTableStatusRowCount]
		@TableStatus = N'''Row Count after loading the star schema'''
	--
   EXEC [Project1].[AddForeignKeysToStarSchemaData];
    --

END;
GO
/****** Object:  StoredProcedure [Project1].[ShowTableStatusRowCount]    Script Date: 11/13/2018 10:11:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Your Name
-- Create date: 
-- Description:	
-- =============================================
/*
			SELECT DISTINCT
				CONCAT(
						  'select TableStatus = ',
						  QUOTENAME(@TableStatus, ''''),
						  ', TableName =',
						  QUOTENAME(FullyQualifiedTableName, ''''),
						  ', COUNT(*) FROM ',
						  '[',
						  SchemaName,
						  '].',
						  TableName
					  )
			FROM Utils.uvw_FindColumnDefinitionPlusDefaultAndCheckConstraint
			WHERE SchemaName LIKE 'c%';
*/


CREATE PROCEDURE [Project1].[ShowTableStatusRowCount] 
 @TableStatus VARCHAR(64)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimCustomer', COUNT(*) FROM [CH01-01-Dimension].DimCustomer
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimGender', COUNT(*) FROM [CH01-01-Dimension].DimGender
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimMaritalStatus', COUNT(*) FROM [CH01-01-Dimension].DimMaritalStatus
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimOccupation', COUNT(*) FROM [CH01-01-Dimension].DimOccupation
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimOrderDate', COUNT(*) FROM [CH01-01-Dimension].DimOrderDate
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimProduct', COUNT(*) FROM [CH01-01-Dimension].DimProduct
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimProductCategory', COUNT(*) FROM [CH01-01-Dimension].DimProductCategory
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimProductSubcategory', COUNT(*) FROM [CH01-01-Dimension].DimProductSubcategory
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimTerritory', COUNT(*) FROM [CH01-01-Dimension].DimTerritory
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.SalesManagers', COUNT(*) FROM [CH01-01-Dimension].SalesManagers
	select TableStatus = @TableStatus, TableName ='CH01-01-Fact.Data', COUNT(*) FROM [CH01-01-Fact].Data

END
GO
/****** Object:  StoredProcedure [Project1].[TruncateStarSchemaData]    Script Date: 11/13/2018 10:11:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [Project1].[TruncateStarSchemaData]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

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
GO
USE [master]
GO
ALTER DATABASE [BIClass] SET  READ_WRITE 
GO

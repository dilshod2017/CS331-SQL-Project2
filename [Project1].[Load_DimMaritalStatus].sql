USE [BIClass]
GO
/****** Object:  StoredProcedure [Project1].[Load_DimMaritalStatus]    Script Date: 11/16/2018 8:33:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		YourName Hangjin Chen
-- Create date: 11/16/2018 3:15PM
-- Description:	
-- =============================================
if OBJECT_ID('[Project1].[Load_DimMaritalStatus]','p') is not null
	drop proc [Project1].[Load_DimMaritalStatus];
go

create PROCEDURE [Project1].[Load_DimMaritalStatus]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 exec [Project1].[TruncateStarSchemaData]
	 exec [Project1].[DropForeignKeysFromStarSchemaData]

	 alter table [CH01-01-Dimension].[DimMaritalStatus] add ClassTime varchar(5) null default '09:15';
	 alter table [CH01-01-Dimension].[DimMaritalStatus] add LastName  varchar(30) null default 'Chen';
	 alter table [CH01-01-Dimension].[DimMaritalStatus] add FirstName   varchar(30) null default 'Hangjin';
	 alter table [CH01-01-Dimension].[DimMaritalStatus] add DateAdded datetime2 null default sysdatetime();

	 exec [Project1].AddForeignKeysToStarSchemaData

	INSERT INTO [CH01-01-Dimension].[DimMaritalStatus]
	([MaritalStatus], [MaritalStatusDescription])

SELECT DISTINCT [MaritalStatus],
	   CASE
			WHEN MaritalStatus = 'S' THEN 'Single'
			ELSE 'Married' END
	   AS [MaritalStatusDescription]
FROM [FileUpload].[OriginallyLoadedData]
PRINT 'Load_DimMaritalStatus done'

END

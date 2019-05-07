USE [ETLCourse]
GO
/****** Object:  StoredProcedure [dbo].[stp_BuildNormalizedTable]    Script Date: 2019-05-07 3:36:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[stp_BuildNormalizedTable] @table NVARCHAR(100) 
AS 
  BEGIN 
      DECLARE @cleanTable NVARCHAR(100), 
              @s          NVARCHAR(MAX) 

      SET @cleanTable=REPLACE(@table, '_Stocks', 'HistoricalData') 
      SET @s = 'CREATE TABLE' + @cleanTable + '(ID INT IDENTITY(1,1),Price DECIMAL(13,4),PriceDate DATE) 
	   INSERT INTO'  + @cleanTable 
               + '(Price,PriceDate) 
			   SELECT [Adj Close],[Date] FROM' 
               + @table + ' ORDER BY Date ASC' 

      --PRINT @s 
	  EXECUTE sp_executesql @s
  END 

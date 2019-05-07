CREATE PROC Stp_buildnormalizedtable @table NVARCHAR(100) 
AS 
  BEGIN 
      DECLARE @cleanTable NVARCHAR(100), 
              @s          NVARCHAR(max) 

      SET @cleanTable=Replace(@table, '_stocks', 'HistoricalDate') 
      SET @s = 'Create Table' + @cleanTable 
               + 
      '(ID INT IDENTITY(1,1),Price Decimal(13,4),PriceDate DATE) Insert into' 
               + @cleanTable 
               + '(Price,PriceDate) SELECT [Adj Close],[Date] FROM' 
               + @table + ' ORDER BY Date ASC' 

      PRINT @s 
  END 

EXEC Stp_buildnormalizedtable 
  '[dbo].[AAPL_Stocks]' 
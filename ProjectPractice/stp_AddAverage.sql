ALTER PROCEDURE [dbo].[Stp_addaverage] @t NVARCHAR(250), 
                                       @v NVARCHAR(250) 
AS 
  BEGIN 
      DECLARE @id NVARCHAR(25) 

      SELECT @id = column_name 
      FROM   information_schema.columns 
      WHERE  table_name = @t 
             AND column_name LIKE '%ID%' 

      DECLARE @add NVARCHAR(max), 
              @s   NVARCHAR(max) 

      SET @add='Alter table ' + Quotename(@t) 
               + ' Add Avg Decimal(13,4)' 

      EXEC Sp_executesql 
        @add 

      SET @s = 'DECLARE @first int = 1, @second int = 2, @avg Decimal(13,4),@max INT SELECT @max=MAX(' + Quotename(@id) + ') FROM ' 
               + Quotename(@t) + ' WHILE @second <= @max BEGIN SELECT @avg = AVG(' 
               + Quotename(@v) + ') FROM ' + Quotename(@t) + ' WHERE ' 
               + Quotename(@id) + ' Between @first and @second UPDATE ' + Quotename(@t) 
               + ' SET Avg = @avg WHERE ' + Quotename(@id) + ' =@second SET @second = @second + 1 END' 

      --print @s 
      EXECUTE Sp_executesql 
        @s 
  END 
--Execute [dbo].[stp_AddAverage] AAPLHistoricalData,Price 
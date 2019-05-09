ALTER PROCEDURE stp_AddDetailDataBasisOnDate @t NVARCHAR(250), 
											  @d NVARCHAR(250) 
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
               + ' Add Date INT,  Year INT, Month INT, Quarter INT' 
			   print @add
	EXEC Sp_executesql 
        @add 

	  SET @s ='DECLARE @r INT = 1, @day INT,@year INT, @month INT,@quarter INT,  @max INT
	  SELECT @max = MAX(' + QUOTENAME(@id) + ') FROM ' + QUOTENAME(@t) + '
	  WHILE @r<=@max
	  BEGIN

	  SELECT @day = DAY(' +QUOTENAME(@d)+ ') FROM ' +QUOTENAME(@t)+ ' WHERE ID = @r
	  UPDATE ' + QUOTENAME(@t) + '
	  SET Date = @day WHERE ' + QUOTENAME(@id) + ' = @r   

	    SELECT @year = YEAR(' +QUOTENAME(@d)+ ') FROM ' +QUOTENAME(@t)+ ' WHERE ID = @r
	  UPDATE ' + QUOTENAME(@t) + '
	  SET Year = @year WHERE ' + QUOTENAME(@id) + ' = @r

	    SELECT @month = Month(' +QUOTENAME(@d)+ ') FROM ' +QUOTENAME(@t)+ ' WHERE ID = @r
	  UPDATE ' + QUOTENAME(@t) + '
	  SET Month = @month WHERE ' + QUOTENAME(@id) + ' = @r

	    SELECT @quarter = DATEPART(quarter, ' +QUOTENAME(@d)+ ') FROM ' +QUOTENAME(@t)+ ' WHERE ID = @r
	  UPDATE ' + QUOTENAME(@t) + '
	  SET Quarter = @quarter WHERE ' + QUOTENAME(@id) + ' = @r

	  SET @r = @r+1
	  END

	  '
	  	EXECUTE sp_executesql @s

END



--
--execute stp_AddDetailDataBasisOnDate AAPLHistoricalData,PriceDate
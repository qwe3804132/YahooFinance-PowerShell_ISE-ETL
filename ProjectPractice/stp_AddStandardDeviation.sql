Alter PROCEDURE stp_AddStandardDeviation
@t NVARCHAR(250)
,@v NVARCHAR(250)
--,@id NVARCHAR(25) -- if multiple ID fields, specify
AS
BEGIN

	DECLARE @id NVARCHAR(25)
	
	SELECT @id = COLUMN_NAME 
	FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE TABLE_NAME = @t 
		AND COLUMN_NAME LIKE '%ID%'

	DECLARE @add NVARCHAR(MAX), @s NVARCHAR(MAX)
	
	SET @add = 'ALTER TABLE ' + QUOTENAME(@t) + ' ADD StDev DECIMAL(13,4)'
	
	EXEC sp_executesql @add




	SET @s = 'DECLARE @first INT = 1, @second INT = 2, @stdev DECIMAL(13,4), @max INT
	SELECT @max = MAX(' + QUOTENAME(@id) + ') FROM ' + QUOTENAME(@t) + '

	WHILE @second <= @max
	BEGIN

		SELECT @stdev = STDEV(' + QUOTENAME(@v) + ') 
			FROM ' + QUOTENAME(@t) + ' 
			WHERE ' + QUOTENAME(@id) + ' BETWEEN @first AND @second

		UPDATE ' + QUOTENAME(@t) + '
		SET StDev = @stdev
		WHERE ' + QUOTENAME(@id) + ' = @second

		SET @second = @second + 1

	END'

	--PRINT @s
	EXECUTE sp_executesql @s

END


--execute [dbo].[stp_AddStandardDeviation] AAPLHistoricalData, Price
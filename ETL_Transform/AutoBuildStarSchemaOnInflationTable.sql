CREATE PROCEDURE stp_BuildStarSchema
@t NVARCHAR(100)
AS
BEGIN

	DECLARE @loop TABLE (LoopID INT IDENTITY(1,1), ColumnName NVARCHAR(100))

	INSERT INTO @loop (ColumnName)
	SELECT COLUMN_NAME
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = @t
		AND COLUMN_NAME NOT LIKE '%ID%'

	DECLARE @c NVARCHAR(100), @b INT = 1, @m INT, @s NVARCHAR(MAX)
	SELECT @m = MAX(LoopID) FROM @loop

	WHILE @b <= @m
	BEGIN
		
		SELECT @c = ColumnName FROM @loop WHERE LoopID = @b

		SET @s = 'DECLARE @cnt INT

		;WITH CTE AS(
			SELECT DISTINCT ' + QUOTENAME(@c) + ' AS CountValue
			FROM ' + QUOTENAME(@t) + '
		)
		SELECT @cnt = COUNT(CountValue) FROM CTE
		IF @cnt < 1000
		BEGIN

			CREATE TABLE ' + QUOTENAME(@t + @c) + '(
				' + QUOTENAME(@c + 'ID') + ' SMALLINT IDENTITY(1,1) PRIMARY KEY
				, ' + QUOTENAME(@c) + ' VARCHAR(500)
			)

			;WITH CTE AS(
				SELECT DISTINCT ' + QUOTENAME(@c) + ' 
				FROM ' + QUOTENAME(@t) + '
			)
			INSERT INTO ' + QUOTENAME(@t + @c) + ' (' + QUOTENAME(@c) + ')
			SELECT RTRIM(LTRIM(' + QUOTENAME(@c) + '))
			FROM CTE

			PRINT ''The column ' + QUOTENAME(@c) + ' became ' + QUOTENAME(@t + @c) + '.''

			ALTER TABLE ' + QUOTENAME(@t) + ' ADD ' + QUOTENAME(@c + 'ID') + ' SMALLINT
		
			UPDATE ' + QUOTENAME(@t) + '
			SET ' + QUOTENAME(@c + 'ID') + ' = ' + QUOTENAME(@t + @c) + '.' + QUOTENAME(@c + 'ID') + '
			FROM ' + QUOTENAME(@t) + '
				INNER JOIN ' + QUOTENAME(@t + @c) + ' ON ' + QUOTENAME(@t) + '.' + QUOTENAME(@c) + ' = ' + QUOTENAME(@t + @c) + '.' + QUOTENAME(@c) + '
			WHERE ' + QUOTENAME(@t) + '.' + QUOTENAME(@c) + ' = ' + QUOTENAME(@t + @c) + '.' + QUOTENAME(@c) + '

			ALTER TABLE ' + QUOTENAME(@t) + ' DROP COLUMN ' + QUOTENAME(@c) + '

			ALTER TABLE ' + QUOTENAME(@t) + ' ADD CONSTRAINT ' +  + QUOTENAME('FK_' + @t + @c) + ' FOREIGN KEY (' + QUOTENAME(@c + 'ID') + ') REFERENCES ' +  + QUOTENAME(@t + @c) + ' (' + QUOTENAME(@c + 'ID') + ')

		END'

		--PRINT @s
		EXECUTE sp_executesql @s

		SET @b = @b + 1

	END

END


/*

-- Calls the stored procedure
EXEC stp_BuildStarSchema 'SeveralColumns'

-- This builds a miniature test version
CREATE TABLE SeveralColumns(
	ID INT IDENTITY(1,1),
	Name VARCHAR(100),
	ThirdColumn VARCHAR(100)
)

INSERT INTO SeveralColumns (Name,ThirdColumn)
VALUES ('John','88')
	, ('Sarah','10000')
	, ('Megan','9')
	, ('Bob','7')
	, ('Hmm','67')

SELECT *
FROM SeveralColumns	
	
-- This deletes all the results so we can restart
DROP TABLE SeveralColumnsName
DROP TABLE SeveralColumnsThirdColumn
DROP TABLE SeveralColumns
	
*/



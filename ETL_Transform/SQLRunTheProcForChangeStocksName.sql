USE ETLCourse
DECLARE @Loop table(
ID INT Identity(1,1),
TableName Nvarchar(100))


Insert into @Loop (TableName)
select TABLE_NAME
from INFORMATION_SCHEMA.TABLES where TABLE_NAME like '%_Stocks%'

Declare @b INT = 1, @m INT,@t Nvarchar(100)
select @m = MAX(ID) From @Loop
While @b<=@m
Begin

SELECT @t = TableName from @LOOP Where ID = @b

Execute [dbo].[stp_BuildNormalizedTable] @t
 
set @b = @b+1
end
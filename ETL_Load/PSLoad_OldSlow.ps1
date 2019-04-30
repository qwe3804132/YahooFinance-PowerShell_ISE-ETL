## Set-ExecutionPolicy unrestricted
## Import-Module SQLPS

Function PSLoad ($server, $database, $table, $path)
{
    $path = $path + $table + ".txt"
    invoke-sqlcmd -query "SELECT * FROM $table" -database $database -serverinstance $server | Out-File -FilePath $path -Encoding ascii
}

PSLoad -server "TIMOTHY\SQLEXPRESS" -database "ETLCourse" -table "Inflation" -path "C:\Users\Timothy Smith\Desktop\udmps\files\ETL_Load\"

## Set-ExecutionPolicy restricted
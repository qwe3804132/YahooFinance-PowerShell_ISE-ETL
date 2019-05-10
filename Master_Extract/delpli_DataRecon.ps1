## 


Function CountData ($file, $ch, $server, $db, $och = $null)
{
    $ext = $file.Substring($file.LastIndexOf("."))
    $name = $file.Substring($file.LastIndexOf("\")+1).Replace($ext,"")
 
    $scon = New-Object System.Data.SqlClient.SqlConnection
    $scon.ConnectionString = "SERVER=$server;DATABASE=$db;Integrated Security=true"
    $cmd = New-Object System.Data.SqlClient.SqlCommand
    $cmd.Connection = $scon
 
    $lineno = 0
 
    $read = New-Object System.IO.StreamReader($file)
 
    while (($line = $read.ReadLine()) -ne $null)
    {
        $lineno++
        $total = $line.Split($ch).Length - 1;
        if ($och -eq $null)
        {
            $cmd.CommandText = "IF OBJECT_ID('$name') IS NULL BEGIN CREATE TABLE $name ([LineNumber] BIGINT, [CharCount] BIGINT) END  INSERT INTO $name VALUES ($lineno,$total)"
        }
        else
        {
            $ototal = $line.Split($och).Length - 1;
            $cmd.CommandText = "IF OBJECT_ID('$name') IS NULL BEGIN CREATE TABLE $name ([LineNumber] BIGINT, [CharCount] INT, [OtherCharCount] INT) END  INSERT INTO $name VALUES ($lineno,$total,$ototal)"
        }
        $scon.Open()
        $cmd.ExecuteNonQuery()
        $scon.Close()
    }
 
    $read.Close()
    $read.Dispose()
    $scon.Dispose()
}
 
CountData -file "C:\files\file.txt" -ch "," -server "" -db ""
##
##SELECT CharCount , Count(LineNumber) from delfire GROUP BY CharCount

## M
Function CountData_OneTable ($file, $ch, $server, $db, $name, $och = $null)
{
    $scon = New-Object System.Data.SqlClient.SqlConnection
    $scon.ConnectionString = "SERVER=$server;DATABASE=$db;Integrated Security=true"
    
    $cmd = New-Object System.Data.SqlClient.SqlCommand
    $cmd.Connection = $scon
    
    $read = New-Object System.IO.StreamReader($file)
    
    while (($line = $read.ReadLine()) -ne $null)
    {
        $total = $line.Split($ch).Length - 1;
        if ($och -eq $null)
        {
            $cmd.CommandText = "IF OBJECT_ID('$name') IS NULL BEGIN CREATE TABLE $name ([LineNumber] BIGINT IDENTITY(1,1), [CharCount] INT) END  INSERT INTO $name ([CharCount] VALUES($total)"
        }
        else
        {
            $ototal = $line.Split($och).Length - 1;
            $cmd.CommandText = "IF OBJECT_ID('$name') IS NULL BEGIN CREATE TABLE $name ([LineNumber] BIGINT IDENTITY(1,1), [CharCount] INT, [OtherCharCount] INT) END  INSERT INTO $name ([CharCount],[OtherCharCount]) VALUES ($total,$ototal)"
        }
        $scon.Open()
        $cmd.ExecuteNonQuery()
        $scon.Close()
    }
    $read.Close()
    $read.Dispose()
    $scon.Dispose()
}
Function ExportQueryToExcel ($server, $database, $path, $table)
{
    $file = $path + $table + ".xlsx"
    $query = "SELECT * FROM " + $table

    if ((Test-Path $file) -eq $True)
    {
        Remove-Item $file
    }
 
    $scon = New-Object System.Data.SqlClient.SqlConnection
    $scon.ConnectionString = "SERVER=" + $server + ";DATABASE=" + $database + ";Integrated Security=true"
    $cmd = New-Object System.Data.SqlClient.SqlCommand
    $cmd.Connection = $scon
    $cmd.CommandText = $query
 
    $excel = New-Object -ComObject Excel.Application
    $wkbk = $excel.Workbooks.Add()
    $wksh = $wkbk.ActiveSheet
    $cells = $wksh.Cells
    $excel.Visible=$True
 
    $scon.Open()
    $sqlread = $cmd.ExecuteReader()
    $i = 1
 
    while ($sqlread.Read())
    {
        if ($i -eq 1)
        {
            for ($x = 1; $x -le $sqlread.FieldCount; $x++)
            {
                $cells.Item($i,$x) = $sqlread.GetName(($x-1))
            }
            for ($z = 1; $z -le $sqlread.FieldCount; $z++)
            {
                $cells.Item(($i+1),$z) = $sqlread.GetValue(($z-1))
            }
        }
        else
        {
            for ($y = 1; $y -le $sqlread.FieldCount; $y++)
            {
                $cells.Item(($i+1),$y) = $sqlread.GetValue(($y-1))
            }
        }
        $i++
    }
 
    $scon.Close()
    $scon.Dispose()
    $sqlread.Close()
    $sqlread.Dispose()
 
    $wkbk.SaveAs($file)
    #$excel.Quit()
 
 
    #if ((Get-Process -ProcessName EXCEL) -ne $False)
    #{
    #    Stop-Process -ProcessName EXCEL
    #}
}
 
ExportQueryToExcel -server "OURSERVER" -database "OurDatabase" -path "C:\files\Excel\" -table "OurTable"


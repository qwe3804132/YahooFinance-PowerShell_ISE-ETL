Function ExportWSToCSV_Clean ($excelFileName, $csvLoc)
{
    $excelFile = "C:\files\Excel\" + $excelFileName + ".xlsx"
    $E = New-Object -ComObject Excel.Application
    $E.Visible = $false
    $E.DisplayAlerts = $false
    $wb = $E.Workbooks.Open($excelFile)
    foreach ($ws in $wb.Worksheets)
    {
        $maxrow = $ws.UsedRange.Cells | Select-Object -Last 1 | Select-Object -Property Row
        $maxrow = $maxrow.Row
        $maxcol = $ws.UsedRange.Cells | Select-Object -Last 1 | Select-Object -Property Column
        $maxcol = $maxcol.Column

        for ($c = 1; $c -le $maxcol; $c++)
        {
            for ($r = 1; $r -le $maxrow; $r++)
            {
                if ($ws.Cells.Item($r,$c).Value() -like "*,*")
                {
                    $ws.Cells.Item($r,$c).Value() = $ws.Cells.Item($r,$c).Value().Replace(",","")
                }
                elseif (($ws.Cells.Item($r,$c).Value()*0) -eq 0)
                {
                    $ws.Cells.Item($r,$c).NumberFormat ="0"
                }
            }
        }
        $n = $excelFileName + "_" + $ws.Name
        $ws.SaveAs($csvLoc + $n + ".csv", 6)
    }
    $E.Quit()
 
    if (Get-Process -ProcessName EXCEL)
    {
        Stop-Process -ProcessName EXCEL
    }
}
 
ExportWSToCSV_Clean -excelFileName "file" -csvLoc "C:\files\Excel\CSV\"
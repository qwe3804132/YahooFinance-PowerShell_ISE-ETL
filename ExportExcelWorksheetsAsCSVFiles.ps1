Function ExportWSToCSV ($excelfilename, $csvLoc)
{
    $en = $excelfilename.Split("\") | Select-Object -Last 1
    $en = $en.Split(".") | Select-Object -First 1
    $E = New-Object -ComObject Excel.Application
    $E.Visible = $false
    $E.DisplayAlerts = $false
    $wb = $E.Workbooks.Open($excelfilename)
    foreach ($ws in $wb.Worksheets)
    {
        $n = $en + "_" + $ws.Name
        $ws.SaveAs($csvLoc + $n + ".csv", 6)
    }
    $E.Quit()
    stop-process -processname EXCEL
}

## Edit where the CSVs will go and where the Excel files currently are!
$ens = Get-ChildItem "\\Mac\Home\Desktop\SSISCode\Code\" -filter *.xlsx

foreach($e in $ens)
{
    ExportWSToCSV -excelfilename $e.FullName -csvLoc "\\Mac\Home\Desktop\SSISCode\Code\csvTesting\"
}


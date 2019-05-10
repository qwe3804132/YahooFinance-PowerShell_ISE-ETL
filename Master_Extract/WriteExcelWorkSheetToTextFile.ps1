Function WriteExcelWorkSheetToTextFile ($textfile, $excelfile, $sheet)
{
    if ((Test-Path $textfile) -eq $true)
    {
        Remove-Item $textfile
    }
 
    New-Item $textfile -ItemType file
 
    $file = New-Object -ComObject Excel.Application
    $file.Visible = $false
    $file.DisplayAlerts = $false
    $open = $file.Workbooks.Open("$excelfile")
    $first = $open.WorkSheets | Where-Object {$_.Name -like "*$sheet*" }
 
    $maxrow = $first.UsedRange.Cells | Select-Object -Last 1 | Select-Object -Property Row
    $maxrow = $maxrow.Row
    $maxcol = $first.UsedRange.Cells | Select-Object -Last 1 | Select-Object -Property Column
    $maxcol = $maxcol.Column
 
 
    for ($r = 1; $r -le $maxrow; $r++)
    {
        $e_array = New-Object System.Text.StringBuilder
        for ($c = 1; $c -le $maxcol; $c++)
        {
            if ($c -ne $maxcol)
            {
                $ev = $first.Cells.Item($r,$c).Value().ToString() + ","
                $e_array.Append($ev)
            }
            else
            {
                $ev = $first.Cells.Item($r,$c).Value().ToString()
                $e_array.Append($ev)
            }
        }
        $e_array.ToString() | Out-File $textfile -Append
    }
 
    if ((Get-Process -ProcessName EXCEL) -ne $null)
    {
        Stop-Process -ProcessName EXCEL
    }
}
 
WriteExcelWorkSheetToTextFile -textfile "C:\files\OurExportedTextFile.txt" -excelfile "C:\files\OurExcelFile.xlsx" -sheet "Sheet1"
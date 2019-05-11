Function SeparateGoodBadLines_Strip ($file, $ch, [string[]]$strip)
{
    $ext = $file.Substring($file.LastIndexOf("."))
    $loc = $file.Substring(0,($file.LastIndexOf("\")+1))
    $name = $file.Substring($file.LastIndexOf("\")+1).Replace($ext,"")
    
    $valid = Get-Content $file | Select -First 1
    $validCount = $valid.Split($ch).Length - 1
 
    $valid = $loc + $name + "_valid" + $ext
    $invalid = $loc + $name + "_invalid" + $ext
 
    New-Item $valid -ItemType file
    New-Item $invalid -ItemType file
 
    $read = New-Object System.IO.StreamReader($file)
    $wValid = New-Object System.IO.StreamWriter($valid)
    $wInvalid = New-Object System.IO.StreamWriter($invalid)
 
 
    while (($line = $read.ReadLine()) -ne $null)
    {
        $total = $line.Split($ch).Length - 1
        if ($total -eq $validCount)
        {
            foreach ($st in $strip)
            {
                $line = $line.Replace("$st","")
            }
            $wValid.WriteLine($line)
            $wValid.Flush()
        }
        else
        {
            $wInvalid.WriteLine($line)
            $wInvalid.Flush()
        }
    }
 
 
    $read.Close()
    $read.Dispose()
    $wValid.Close()
    $wValid.Dispose()
    $wInvalid.Close()
    $wInvalid.Dispose()
}
 
SeparateGoodBadLines -file "C:\files\dirtyfile.txt" -ch "," -strip @("$","*","!","#")
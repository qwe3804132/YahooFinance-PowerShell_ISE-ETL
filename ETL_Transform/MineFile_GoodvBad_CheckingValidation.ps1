Function MineFile_GoodvBad ($file, $resultfiles, $goodCount)
{
    $read = New-Object System.IO.StreamReader($file)
    $goodfile = $resultfiles + "good.txt"
    $badfile = $resultfiles + "bad.txt"
    New-Item $goodfile -ItemType file
    New-Item $badfile -ItemType file
    $lineNo = 0
    $count = 0
    $goodA = @()
    $badA = @()

    while ($line = $read.ReadLine())
    {
         $count = $line.Split(',').Length -1
     
         if ($count -ne $goodCount)
         {
            $badA += $line
         }
         else
         {
            $goodA += $line
         }

         $lineNo++
    }
    $read.Close()
    $read.Dispose()

    ##$goodA
    $badA
}

MineFile_GoodvBad -file "C:\Users\Timothy Smith\Desktop\udmps\files\ETL_Transform\ourfile.txt" -resultfiles "C:\Users\Timothy Smith\Desktop\udmps\files\ETL_Transform\log\" -goodCount 2
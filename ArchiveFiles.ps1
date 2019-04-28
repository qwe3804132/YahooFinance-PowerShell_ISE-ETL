Function RenameMoveFile($filepath, $archivefolder)
{
    $x = $filepath.Split("\") | Select-Object -Last 1
    $new = $filepath.Replace($x,"") + $archivefolder + "\" + $x

    Move-Item $filepath $new
}


$ens = Get-ChildItem "\\Mac\Home\Desktop\SSISCode\Code\csvTesting\" -filter *.csv

foreach($x in $ens){

RenameMoveFile -filepath $x.FullName -archivefolder "TargetFolder"

}

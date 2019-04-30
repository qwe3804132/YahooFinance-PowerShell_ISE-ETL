
## One file at a time (slow and unnecessary)
AutoImport_Comma -server "PEIRANLIU17B7" -database "ClientMarketing" -filepath "\\Mac\Home\Desktop\SSISCode\Code\inflationdata.csv"   
##


##$multipaleFiles = Get-ChildItem "\\Mac\Home\Desktop\SSISCode\Code\Project_Stocks"  -Filter *.csv
##foreach( $a in $multipaleFiles){

##$x=$a.FullName
 
##AutoImport_Comma -server "PEIRANLIU17B7" -database "ETLCourse" -filepath $x



Function AutoImport_Comma ($server, $database, $filepath)
{
    ## Gets the staging table name
    $tName = $filepath.Split("\") | Select-Object -Last 1
    $tName = $tName.Split(".") | Select-Object -First 1
    
    ## Builds the structure of the staging table structure
    $staging = Get-Content $filepath | Select-Object -First 1
    $staging = $staging.Replace(",","] VARCHAR(MAX), [")
    $staging = "IF OBJECT_ID('" + $tName + "') IS NOT NULL BEGIN DROP TABLE " + $tName + " END CREATE TABLE [" + $tName + "] ([" + $staging + "] VARCHAR(MAX))"

    ## Sets the connection and command parameters
    $scon = New-Object System.Data.SqlClient.SqlConnection
    $scon.ConnectionString = "SERVER=" + $server + ";DATABASE=" + $database + ";Integrated Security=true"
    $buildstaging = New-Object System.Data.SqlClient.SqlCommand
    $buildstaging.Connection = $scon
    $buildstaging.CommandText = $staging

    ## Opens a connection and creates the staging table
    $x = 0
    $scon.Open()
    $buildstaging.ExecuteNonQuery()
    $scon.Close()
    $scon.Dispose()
    $x = 1

    if ($x = 1)
    {
        $tN = $tName
        $scon = New-Object System.Data.SqlClient.SqlConnection
        $scon.ConnectionString = "SERVER=" + $server + ";DATABASE=" + $database + ";Integrated Security=true"
        $bulkinsert = New-Object System.Data.SqlClient.SqlCommand
        $bulkinsert.Connection = $scon
        $bulkinsert.CommandText = "EXECUTE stp_BulkInsert_Comma '$filepath', $tN"

        $scon.Open()
        $bulkinsert.ExecuteNonQuery()
        $scon.Close()
        $scon.Dispose()

    }

}







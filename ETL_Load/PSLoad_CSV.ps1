Function PSLoad_CSV($server, $database, $query, $location, $filename)
{
    $scon = New-Object System.Data.SqlClient.SqlConnection
    $scon.ConnectionString = "SERVER=" + $server + ";DATABASE=" + $database + ";Integrated Security=true"
    $export = $location + $filename + ".csv"

    $cmd = New-Object System.Data.SqlClient.SqlCommand
    $ad = New-Object System.Data.SqlClient.SqlDataAdapter
    $ds = New-Object System.Data.DataSet
    $scon.Open()
    $cmd.CommandText = $query
    $cmd.Connection = $scon
    $ad.SelectCommand = $cmd
    $ad.Fill($ds)
    $scon.Close()
    $ds.Tables[0] | Export-Csv -NoTypeInformation $export
    
}

PSLoad_CSV -server "TIMOTHY\SQLEXPRESS" -database "ETLCourse" -query "SELECT * FROM Inflation" -location "C:\Users\Timothy Smith\Desktop\udmps\files\ETL_Load\" -filename "inflation"
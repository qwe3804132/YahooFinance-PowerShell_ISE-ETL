Function Get-BitstampData {
    Param(
    [string]$connectionstring
    )
    Process
    {

        while ($x = 1)
        {

            $w = (New-Object net.webclient).DownloadString("https://www.bitstamp.net/api/ticker/")
            $p = $w | ConvertFrom-Json

            $last = $p.last
            $timestamp = $p.timestamp
            $volume = $p.volume

            $scon = New-Object System.Data.SqlClient.SqlConnection
            $scon.ConnectionString = "$connectionstring"

            
            $cmd = New-Object System.Data.SqlClient.SqlCommand
            $cmd.Connection = $scon
            $cmd.CommandText = "INSERT INTO BitstampTable VALUES (@1, @2, @3)"
            $cmd.Parameters.Add("@1", $last)
            $cmd.Parameters.Add("@2", $timestamp)
            $cmd.Parameters.Add("@3", $volume)
            
            $scon.Open()
            $cmd.ExecuteNonQuery() | Out-Null
            $scon.Dispose()

            Start-Sleep -s 20

        }
    }
}

###  In the parameter for connection string, put the connection string of your server/database
# FORMAT (if using Windows Authentication): Data Source=MYSERVER\MYINSTANCE;Initial Catalog=MyDatabase;Integrated Security=true

Get-BitstampData -connectionstring "Data Source=PEIRANLIU17B7;Initial Catalog=ETLCourse;Integrated Security=true"

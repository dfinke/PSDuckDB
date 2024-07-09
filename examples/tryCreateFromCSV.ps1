Import-Module $psscriptroot\..\PSDuckDB.psd1 -Force

$path = "$PSScriptRoot\sampleCSV.db"
Remove-Item $path -ErrorAction SilentlyContinue

$conn = New-DuckDBConnection $path

$conn.Open()
$command = $conn.CreateCommand()
$command.CommandText = "CREATE TABLE Sales AS SELECT * FROM 'd:\mygit\PSDuckDB\data\csv\sample\sales1.csv';"
# $null = $command.ExecuteReader()
$command.ExecuteNonQuery()

$command.CommandText = "SELECT * FROM Sales"
$reader = $command.ExecuteReader()

Out-DuckData $reader

<#
you need to Dispose command and reader objects, or even better, put them a try {} catch {} finally {}. In such case, it works as expected.
#>

$command.Dispose()
$reader.Dispose()
$conn.Close()
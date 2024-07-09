Import-Module $psscriptroot\..\PSDuckDB.psd1 -Force


$path = "$PSScriptRoot\sample.db"
Remove-Item $path -ErrorAction SilentlyContinue

$conn = New-DuckDBConnection $path

$conn.Open()
$command = $conn.CreateCommand()
$command.CommandText = 'CREATE TABLE integers(foo INTEGER, bar INTEGER);'
# $null = $command.ExecuteReader()
$command.ExecuteNonQuery()

# $command.CommandText = "INSERT INTO integers VALUES (3, 4), (5, 6), (7, NULL);"
$command.CommandText = @"
INSERT INTO integers VALUES 
(3, 4),
(5, 6), 
(7, NULL);
"@

$command.ExecuteNonQuery();

$command.CommandText = "Select count(*) from integers"
$executeScalar = $command.ExecuteScalar()
$executeScalar

$command.CommandText = "SELECT foo, bar FROM integers"
$reader = $command.ExecuteReader()

Out-DuckData $reader

<#
you need to Dispose command and reader objects, or even better, put them a try {} catch {} finally {}. In such case, it works as expected.
#>

$command.Dispose()
$reader.Dispose()
$conn.Close()
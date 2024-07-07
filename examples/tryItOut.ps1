Import-Module $psscriptroot\..\PSDuckDB.psd1 -Force
<#
you need to Dispose command and reader objects, or even better, put them in using. In such case, it works as expected.
#>

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

while ($reader.read()) {
    # Create a hashtable for the current row
    $rowObject = @{}
    For ($columnIndex = 0; $columnIndex -lt $reader.FieldCount; $columnIndex++ ) {
        # Add field name and value as key-value pair
        $rowObject[$reader.GetName($columnIndex)] = $reader.GetValue($columnIndex)        
    }

    # Convert the hashtable to a custom object and add it to the array
    [PSCustomObject]$rowObject
}

# $command.CommandText = "CHECKPOINT;"
# $null = $command.ExecuteReader()

$command.Dispose()
$reader.Dispose()
$conn.Close()


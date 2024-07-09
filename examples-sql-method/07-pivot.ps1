Import-Module $psscriptroot\..\PSDuckDB.psd1 -Force

$dataset = "$psscriptroot/../data/otherData/cities.csv"

$db = New-DuckDBConnection

$db.sql("CREATE TABLE Cities AS SELECT * FROM '$dataset';")

$db.sql("SELECT * FROM Cities;") | Format-Table

$db.sql(@"
PIVOT Cities
ON Year
USING sum(Population);
"@) | Format-Table

$db.CloseDB()
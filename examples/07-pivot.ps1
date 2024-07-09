Import-Module $psscriptroot\..\PSDuckDB.psd1 -Force

$dataset = "$psscriptroot/../data/otherData/cities.csv"

$stmt = @"
CREATE TABLE Cities AS SELECT * FROM '$dataset';

PIVOT Cities
ON Year
USING sum(Population);
"@

psduckdb -command $stmt | Format-Table

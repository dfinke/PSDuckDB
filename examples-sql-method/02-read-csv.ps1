Import-Module $psscriptroot\..\PSDuckDB.psd1 -Force

#psduckdb -command "SELECT * FROM '$PSScriptRoot\..\data\csv\sample\sales1.csv';" | Format-Table
$db = New-DuckDBConnection

$db.sql("SELECT * FROM '$PSScriptRoot\..\data\csv\sample\sales1.csv';") | Format-Table

$db.CloseDB()
 
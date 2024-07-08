Import-Module $psscriptroot\..\PSDuckDB.psd1 -Force

$db = New-DuckDBConnection

$db.sql("select 10+2") 

$db.CloseDB()
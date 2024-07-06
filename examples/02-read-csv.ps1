Import-Module $psscriptroot\..\PSDuckDB.psd1 -Force

psduckdb -c "SELECT * FROM '$PSScriptRoot\..\data\csv\sample\sales1.csv';" | Format-Table
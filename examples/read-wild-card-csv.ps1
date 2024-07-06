Import-Module $psscriptroot\..\PSDuckDB.psd1 -Force

psduckdb -c "SELECT * FROM '$PSScriptRoot\..\data\csv\sample\*.csv';" | Format-Table
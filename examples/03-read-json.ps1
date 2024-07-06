Import-Module $psscriptroot\..\PSDuckDB.psd1 -Force

psduckdb -c "SELECT * FROM '$PSScriptRoot\..\data\json\sales1.json';" | Format-Table
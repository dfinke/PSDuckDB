Import-Module $psscriptroot\..\PSDuckDB.psd1 -Force

psduckdb -command "SELECT * FROM '$PSScriptRoot\..\data\json\sales*.json';" | Format-Table
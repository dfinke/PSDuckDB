Import-Module $psscriptroot\..\PSDuckDB.psd1 -Force

psduckdb -command "SELECT * FROM '$PSScriptRoot\..\data\parquet\sales.parquet';" | Format-Table

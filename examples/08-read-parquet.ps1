Import-Module $psscriptroot\..\PSDuckDB.psd1 -Force

psduckdb -c "SELECT * FROM '$PSScriptRoot\..\data\parquet\sales.parquet';" | Format-Table

Import-Module $psscriptroot\..\PSDuckDB.psd1 -Force

psduckdb -c "select 10+2"
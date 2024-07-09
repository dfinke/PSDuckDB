Import-Module $psscriptroot\..\PSDuckDB.psd1 -Force

psduckdb -command "select 10+2"
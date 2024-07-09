Import-Module $psscriptroot\..\PSDuckDB.psd1 -Force

#$path = 'https://raw.githubusercontent.com/dfinke/ImportExcel/master/Examples/PassThru/sales.csv'

$db = New-DuckDBConnection

$db.sql(@"
SELECT Item, SUM(UnitSold) AS Total_Sold 
FROM 
'https://raw.githubusercontent.com/dfinke/ImportExcel/master/Examples/PassThru/sales.csv' 
GROUP BY Item 
ORDER BY Item;
"@) | Format-Table

$db.CloseDB()
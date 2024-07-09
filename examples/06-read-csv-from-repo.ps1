Import-Module $psscriptroot\..\PSDuckDB.psd1 -Force

$path = 'https://raw.githubusercontent.com/dfinke/ImportExcel/master/Examples/PassThru/sales.csv'

# psduckdb -command "SELECT * FROM '$path' ORDER BY Item;" | Format-Table

$stmt = @"
SELECT Item, SUM(UnitSold) AS Total_Sold
FROM '$path'
Group By Item
Order By Item;
"@

psduckdb -command $stmt | Format-Table
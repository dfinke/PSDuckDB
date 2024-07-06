Import-Module $psscriptroot\..\PSDuckDB.psd1 -Force

$path = 'https://raw.githubusercontent.com/dfinke/ImportExcel/master/Examples/PassThru/sales.csv'

# psduckdb -c "SELECT * FROM '$path' ORDER BY Item;" | Format-Table

$stmt = @"
SELECT Item, SUM(UnitSold) AS Total_Sold
FROM '$path'
Group By Item
Order By Item;
"@

psduckdb -c $stmt | Format-Table
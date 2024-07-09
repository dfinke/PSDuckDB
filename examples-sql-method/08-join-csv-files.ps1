$db = New-DuckDBConnection

# join customers and orders on customerid
$sql = @"
SELECT * 
FROM '$PSScriptRoot\..\data\orders\customers.csv' c
JOIN '$PSScriptRoot\..\data\orders\orders.csv' o
ON (c.customerid = o.customerid);
"@

$db.sql($sql)[0]
$db.closedb() 
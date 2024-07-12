<# 
SELECT name, count(*) as number_of_readings
FROM readings JOIN systems ON id = system_id
GROUP BY name;
#>

$db = New-DuckDBConnection

# join customers and orders on customerid
$sql = @"
SELECT c.Email, count(*) as number_of_orders
FROM '$PSScriptRoot\..\data\orders\customers.csv' c
JOIN '$PSScriptRoot\..\data\orders\orders.csv' o
ON (c.customerid = o.customerid)
GROUP BY c.Email;
"@

$db.sql($sql)[0]
$db.closedb()
$jsonFile = "$PSScriptRoot/metrics.json"
$dbFile = "$PSScriptRoot/metrics.db"

'powershell/powershell', 'dfinke/psduckdb' | Get-GHMetrics | ConvertTo-Json | Set-Content $jsonFile

$db = New-DuckDBConnection $dbFile

$db.sql(@"
CREATE TABLE metrics AS
SELECT * 
FROM read_json_auto('$jsonFile')
"@)

$db.CloseDB()
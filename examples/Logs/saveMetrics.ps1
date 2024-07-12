'potatoqualitee/PSHelp.Copilot', 'dfinke/psduckdb' | Get-GHMetrics | ConvertTo-Json | Set-Content ./metrics.json

$db = New-DuckDBConnection ./metrics.db

$db.sql(@"
CREATE TABLE metrics AS
SELECT * 
FROM read_json_auto('./metrics.json')
"@)

$db.CloseDB()
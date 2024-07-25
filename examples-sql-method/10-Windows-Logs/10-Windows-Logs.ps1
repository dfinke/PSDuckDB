Get-ChildItem -Path $PSScriptRoot -Filter "*.csv" | Remove-Item -Force -ErrorAction SilentlyContinue
Get-ChildItem -Path $PSScriptRoot -Filter "*.db" | Remove-Item -Force -ErrorAction SilentlyContinue

$date = (Get-Date).AddDays(-1)

$appLog = "$PSScriptRoot\Application.csv"
$sysLog = "$PSScriptRoot\System.csv"
$windowsDDB = "$PSScriptRoot\windowsDDB.db"

Remove-Item $windowsDDB -ErrorAction SilentlyContinue

if (!(Test-Path $appLog)) {
    Write-Host "Reading Application logs from $date" -ForegroundColor Yellow
    $result = Get-WinEvent -FilterHashTable @{ LogName = "Application"; StartTime = $date; } 
    
    $result | Export-Csv $appLog -NoTypeInformation

    Write-Host "Number of entries in Application logs: $($result.Count)" -ForegroundColor Cyan
}

if (!(Test-Path $sysLog)) {
    Write-Host "Reading System logs from $date" -ForegroundColor Yellow
    
    $result = Get-WinEvent -FilterHashTable @{ LogName = "System"; StartTime = $date; }
    $result | Export-Csv $sysLog -NoTypeInformation

    Write-Host "Number of entries in System logs: $($result.Count)" -ForegroundColor Cyan
}

Write-Host "Reading logs into DuckDB" -ForegroundColor Yellow
$db = New-DuckDBConnection -Path $windowsDDB

Write-Host "Creating table Application Log " -ForegroundColor Yellow
$db.sql(@"
CREATE TABLE application_logs AS
SELECT * FROM read_csv_auto('$appLog');
"@)

Write-Host "Creating table System Log " -ForegroundColor Yellow
$db.sql(@"
CREATE TABLE system_logs AS
SELECT * FROM read_csv_auto('$sysLog');
"@)

$errorCount = $db.sql("SELECT COUNT(*) as Application_Errors FROM application_logs WHERE LevelDisplayName = 'Error';")

Write-Host "Number of errors in Application logs: $errorCount" -ForegroundColor Cyan

$recentEntries = $db.sql("SELECT * FROM system_logs ORDER BY TimeCreated DESC LIMIT 10;")
Write-Host "`nMost recent entries in System logs" -ForegroundColor Cyan
$recentEntries | Format-Table

$db.CloseDB()
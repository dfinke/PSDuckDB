Add-Type -Path "$PSScriptRoot\lib\DuckDB.NET.Data.dll"

. $PSScriptRoot\Public\Invoke-PSDuckDb.ps1
. $PSScriptRoot\Public\New-DuckDBConnection.ps1
. $PSScriptRoot\Public\Out-DuckData.ps1
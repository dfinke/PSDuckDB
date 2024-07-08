Import-Module $PSScriptRoot\PSDuckDB.psd1 -Force

function New-DuckDBConnection {
    [CmdletBinding()]
    param (
        [string]$Path = ":memory:"
    )

    $c = [DuckDB.NET.Data.DuckDBConnection]::new("Data Source=$($Path)")
    
    $cmd = $null
    $reader = $null
    
    $c = $c | Add-Member -PassThru -MemberType ScriptMethod -Name sql -Value {
        param([string]$query)
        
        if($this.State -ne 'Open') {
            $this.Open()
        }
        
        $cmd = $this.CreateCommand()
        $cmd.CommandText = $query

        $reader = $cmd.ExecuteReader()

        Out-DuckData $reader
    } -Force

    $c = $c | Add-Member -PassThru -MemberType ScriptMethod -Name CloseDB -Value {
        if ($null -ne $reader) {
            $reader.Dispose()
        }

        if ($null -ne $cmd) {
            $cmd.Dispose()
        }

        $this.Close()
    } -Force

    $c    
}

# $db1 = New-DuckDBConnection2
# $db2 = New-DuckDBConnection2

# $(
#     $db1.sql("select * from 'data\json\*.json';") 
#     $db2.sql("select * from 'data\csv\sample\*.csv';") 
# ) | Format-Table

# $(
#     (New-DuckDBConnection2).sql("select * from 'data\json\*.json';") 
#     (New-DuckDBConnection2).sql("select * from 'data\csv\sample\*.csv';")
# ) | Format-Table

# (New-DuckDBConnection2).sql(@"
# CREATE TABLE Cities AS SELECT * FROM 'data/otherData/cities.csv';

# PIVOT Cities
# ON Year
# USING sum(Population);
# "@) | Format-Table

$dataset = "d:\mygit\PSDuckDB\data\otherData\cities.csv"

$db = New-DuckDBConnection

$db.sql(@"
CREATE TABLE Cities AS SELECT * FROM '$dataset';
SELECT * FROM Cities;
"@) | Format-Table

Write-Host "Pivot data" -ForegroundColor Cyan

$db.sql(@"
PIVOT (SELECT * FROM Cities)
ON Year
USING sum(Population);
"@) | Format-Table

$db.CloseDB()
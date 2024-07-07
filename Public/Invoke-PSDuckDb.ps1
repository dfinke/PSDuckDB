function Invoke-PSDuckDB {
    <#
    .EXAMPLE
CREATE TABLE Cities AS SELECT * FROM 'data/otherData/cities.csv';

PIVOT Cities
ON Year
USING sum(Population);
    #>
    [CmdletBinding()]
    [Alias('psduckdb')]
    param(        
        [string]$Command
    )

    $conn = [DuckDB.NET.Data.DuckDBConnection]::new("Data Source=:memory:")
    $conn.Open()
    $duckCommand = $conn.CreateCommand()

    if (![string]::IsNullOrEmpty($Command)) {
        $duckCommand.CommandText = $Command

        try {
            $reader = $duckCommand.ExecuteReader()
            Out-DuckData $reader
        }
        catch {
            Write-Host $_.Exception.Message -ForegroundColor Red
        }
        finally {
            if ($null -ne $reader) {
                $reader.Dispose()
            }
            $duckCommand.Dispose()
            $conn.Close()
        }
    }
    else {
        $ExitOn = @("exit", "quit", "bye")

        Write-Host "Welcome to PSDuckDB! $(Get-Date)"
        Write-Host 'Connected to ' -NoNewline
        Write-Host 'a transient in-memory database' -ForegroundColor Red

        while ($true) {
            $targetCommand = Read-Host "PSDuckDB"
        
            if ($targetCommand -in $ExitOn) {
                break
            }

            try {
                $duckCommand.CommandText = $targetCommand
                $reader = $duckCommand.ExecuteReader()
            
                Out-DuckData $reader | Format-Table
            }
            catch {
                Write-Host $_.Exception.Message -ForegroundColor Red
            }
        }
        
        if ($null -ne $reader) {
            $reader.Dispose()
        }
        
        $duckCommand.Dispose()
        $conn.Close()
    }

}
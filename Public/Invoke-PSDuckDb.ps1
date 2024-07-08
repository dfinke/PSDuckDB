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
        [string]$FileName,
        [string]$Command
    )
    
    if (![string]::IsNullOrEmpty($Command)) {        
        $conn = New-DuckDBConnection
        $conn.Open()
        $duckCommand = $conn.CreateCommand()
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
        
        if ([string]::IsNullOrEmpty($FileName)) {
            $FileName = ":memory:"
        }

        Write-Host "Welcome to PSDuckDB! $(Get-Date)"
        Write-Host 'Connected to ' -NoNewline
        if($FileName -eq ":memory:") {
            Write-Host 'an in-memory database' -ForegroundColor Red
        }
        else {
            Write-Host $FileName -ForegroundColor Red
        }
        
        $conn = New-DuckDBConnection -Path $FileName
        $conn.Open()
        $duckCommand = $conn.CreateCommand()

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
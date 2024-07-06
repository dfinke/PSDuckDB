function Invoke-PSDuckDB {
    [CmdletBinding()]
    [Alias('psduckdb')]
    param()

    $ExitOn = @("exit", "quit", "bye")

    $conn = [DuckDB.NET.Data.DuckDBConnection]::new("Data Source=:memory:")
    $conn.Open()
    $duckCommand = $conn.CreateCommand()
    
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

    $conn.Close()
}

function Out-DuckData {
    param($reader)

    while ($reader.read()) {
        # Create a hashtable for the current row
        $rowObject = @{}
        For ($columnIndex = 0; $columnIndex -lt $reader.FieldCount; $columnIndex++ ) {
            # Add field name and value as key-value pair
            $rowObject[$reader.GetName($columnIndex)] = $reader.GetValue($columnIndex)        
        }
    
        # Convert the hashtable to a custom object and add it to the array
        [PSCustomObject]$rowObject
    }
}

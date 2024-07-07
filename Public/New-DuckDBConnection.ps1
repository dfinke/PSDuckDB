<#
.SYNOPSIS
Creates a new connection to a DuckDB database.

.DESCRIPTION
The New-DuckDBConnection function creates a new connection to a DuckDB database using the specified path.

.PARAMETER Path
The path to the DuckDB database file. If not specified, the connection will be created to an in-memory database.

.EXAMPLE
PS C:\> New-DuckDBConnection
Creates a new connection to an in-memory DuckDB database.

.EXAMPLE
PS C:\> $connection = New-DuckDBConnection .\sales.csv
Creates a new connection to a DuckDB database using the specified CSV file.
#>

function New-DuckDBConnection {
    [CmdletBinding()]
    param (
        [string]$Path = ":memory:"
    )
  
    [DuckDB.NET.Data.DuckDBConnection]::new("Data Source=$Path")
}
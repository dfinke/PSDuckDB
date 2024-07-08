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

<#
.SYNOPSIS
Executes a SQL query on a DuckDB connection.

.DESCRIPTION
This script method executes a SQL query on a DuckDB connection. It checks if the connection is open, and if not, it opens the connection. It then creates a command object, sets the command text to the provided query, and executes the command. The result is returned as a DuckDBDataReader object.

.PARAMETER query
The SQL query to be executed.

.EXAMPLE
PS> $connection.sql("SELECT * FROM Customers")
This example executes the SQL query "SELECT * FROM Customers" on the DuckDB connection object named $connection.

#>
Update-TypeData -TypeName 'DuckDB.NET.Data.DuckDBConnection' -MemberType ScriptMethod -MemberName sql -Force -Value {
    param([string]$query)
        
    if ($this.State -ne 'Open') {
        $this.Open()
    }
        
    $cmd = $this.CreateCommand()
    $cmd.CommandText = $query

    $reader = $cmd.ExecuteReader()

    Out-DuckData $reader
}

<#
.SYNOPSIS
Closes the DuckDB connection and disposes of any associated resources.

.DESCRIPTION
The CloseDB method is used to close the DuckDB connection and dispose of any associated resources such as the reader and command objects.

.PARAMETER None

.INPUTS
None. You cannot pipe objects to this method.

.OUTPUTS
None. This method does not generate any output.

.EXAMPLE
CloseDB

This example demonstrates how to use the CloseDB method to close the DuckDB connection.

#>

Update-TypeData -TypeName 'DuckDB.NET.Data.DuckDBConnection' -MemberType ScriptMethod -MemberName CloseDB -Force -Value {
    if ($null -ne $reader) {
        $reader.Dispose()
    }

    if ($null -ne $cmd) {
        $cmd.Dispose()
    }

    $this.Close()
}

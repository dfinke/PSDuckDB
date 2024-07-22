function Join-Data {
    <#
        .SYNOPSIS
        Join two data sources on a common column

        .DESCRIPTION
        Join two data sources on a common column. The data sources can be CSV or JSON files.
        
        .EXAMPLE
        # Join two CSV files on the customerid column
         Join-Data .\data\orders\customers.csv .\data\orders\orders.csv customerid 

        .EXAMPLE
        # Join two JSON files on the customerid column
         Join-Data .\data\orders\customers.json .\data\orders\orders.json customerid

         .EXAMPLE
        # Join a CSV and a JSON file on the customerid column
         Join-Data .\data\orders\customers.csv .\data\orders\orders.json customerid
    #>

    [CmdletBinding()]
    param(
        [string]$Table1,
        [string]$Table2,
        [string]$JoinColumn1,
        [string]$JoinColumn2
    )

    $db = New-DuckDBConnection
    if ([string]::IsNullOrEmpty($JoinColumn2)) {
        $JoinColumn2 = $JoinColumn1
    }

    $sql = @"
SELECT *
FROM '$Table1' t1
JOIN '$Table2' t2
ON (t1.$($JoinColumn1) = t2.$($JoinColumn2));
"@

    Write-Verbose $sql

    $db.sql($sql)
    $db.closedb()
}
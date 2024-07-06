# PSDuckDB
PSDuckDB is a PowerShell module that provides seamless integration with DuckDB, enabling efficient execution of analytical SQL queries directly from the PowerShell environment.

https://duckdb.org/why_duckdb

## Why DuckDB
There are many database management systems (DBMS) out there. But there is no one-size-fits all database system. All take different trade-offs to better adjust to specific use cases. DuckDB is no different.

To start with, DuckDB is a relational (table-oriented) DBMS that supports the Structured Query Language (SQL).

## Simple
SQLite is the world's most widely deployed DBMS. Simplicity in installation, and embedded in-process operation are central to its success. DuckDB adopts these ideas of simplicity and embedded operation.

## Portable
Thanks to having no dependencies, DuckDB is extremely portable.

## Feature-Rich
DuckDB provides serious data management features.

## Fast
DuckDB is designed to support analytical query workloads, also known as [online analytical processing (OLAP)](https://en.wikipedia.org/wiki/Online_analytical_processing). 

## Free
DuckDB's development started while the main developers were public servants in the Netherlands. 

## Examples

Check out the `SQL Introduction` and details for `DuckDB` https://duckdb.org/docs/sql/introduction

### Basic 
[basic.ps1](examples/01-basic.ps1)

```powershell
psduckdb -c "select 10+2"
```

```ps
(10 + 2)
--------
      12
```

### Read CSV
[read-csv.p1](examples/02-read-csv.ps1)

```powershell
psduckdb -c "SELECT * FROM '$PSScriptRoot\..\data\csv\sample\sales1.csv';" | Format-Table
```

```powershell
Region Tag    Units  Price State     Source
------ ---    -----  ----- -----     ------
West   Sales1   927 923.71 Texas     csv
North  Sales1   466 770.67 Tennessee csv
East   Sales1   520 458.68 Florida   csv
East   Sales1   828 661.24 Maine     csv
```

### Read from Repo
[read-csv-from-repo](examples/06-read-csv-from-repo.ps1)

```powershell
$path = 'https://raw.githubusercontent.com/dfinke/ImportExcel/master/Examples/PassThru/sales.csv'

$stmt = @"
SELECT Item, SUM(UnitSold) AS Total_Sold
FROM '$path'
Group By Item
Order By Item;
"@

psduckdb -c $stmt | Format-Table
```

```powershell
Total_Sold Item
---------- ----
       272 Apple
       416 Banana
       234 Kale
       165 Pear
       137 Potato
```

### Pivot the Data
[pivot.ps1](examples/07-pivot.ps1)

```powershell
$dataset = "$psscriptroot/../data/otherData/cities.csv"

$stmt = @"
CREATE TABLE Cities AS SELECT * FROM '$dataset';

PIVOT Cities
ON Year
USING sum(Population);
"@

psduckdb -c $stmt | Format-Table
```

```powershell
Name          Country 2000 2010 2020
----          ------- ---- ---- ----
Amsterdam     NL      1005 1065 1158
New York City US      8015 8175 8772
Seattle       US       564  608  738
```
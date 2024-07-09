# PSDuckDB
PSDuckDB is a PowerShell module that provides seamless integration with DuckDB, enabling efficient execution of analytical SQL queries directly from the PowerShell environment.

https://duckdb.org/why_duckdb

![alt text](DuckDBAtAGlance.png)

## Installation

```powershell
Install-Module PSDuckDB 
```
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

Refer to the [Data Import](https://duckdb.org/docs/data/overview) section for more information.

### Basic 
[basic.ps1](examples/01-basic.ps1)

```powershell
psduckdb -command "select 10+2"
```

```ps
(10 + 2)
--------
      12
```

### Read CSV
[read-csv.p1](examples/02-read-csv.ps1)

```powershell
psduckdb -command "SELECT * FROM '$PSScriptRoot\..\data\csv\sample\sales1.csv';" | Format-Table
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

psduckdb -command $stmt | Format-Table
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

psduckdb -command $stmt | Format-Table
```

```powershell
Name          Country 2000 2010 2020
----          ------- ---- ---- ----
Amsterdam     NL      1005 1065 1158
New York City US      8015 8175 8772
Seattle       US       564  608  738
```

### Import Parquet Files
[read-parquet](examples/08-read-parquet.ps1)

```powershell
psduckdb -command "SELECT * FROM '$PSScriptRoot\..\data\parquet\sales.parquet';" | Format-Table
```

```powershell
Price   Region State        Units
-----   ------ -----        -----
923.71  West   Texas          927
770.67  North  Tennessee      466
458.68w East   Florida        520
661.24  East   Maine          828
53.58   West   Virginia       465
235.67  North  Missouri       436
992.47  South  Kansas         214
640.72  North  North Dakota   789
508.55  South  Delaware       712
```

## CLI API
The PSDuckDB CLI (Command Line Interface) is simple cli interface. 

```powershell
PS C:\> psduckdb
```

```ps
Welcome to PSDuckDB! 07/06/2024 13:03:42
Connected to a transient in-memory database

PSDuckDB:
```

### Examples

Select a string.
```powershell
PSDuckDB: select 'quack' as my_col

my_col
------
quack
```

Generate a series of numbers from 0 to 5.
```powershell
PSDuckDB: SELECT * FROM generate_series(5);

generate_series
---------------
              0
              1
              2
              3
              4
              5
```

Read a parquet file from a local path.

```powershell
PSDuckDB: select * from 'D:\yourpath\sales.parquet'

Units Region Price   State
----- ------ -----   -----
  927 West   923.71  Texas
  466 North  770.67  Tennessee
  520 East   458.68w Florida
  828 East   661.24  Maine
  465 West   53.58   Virginia
  436 North  235.67  Missouri
  214 South  992.47  Kansas
  789 North  640.72  North Dakota
  712 South  508.55  Delaware
```

## Development

Please also refer the the [Contribution Guide](CONTRIBUTING.md).



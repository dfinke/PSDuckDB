# 0.1.2

### Additions:
- Add options to output data as JSON or CSV in `Invoke-PSDuckDb.ps1`.
- Add PowerShell script to retrieve GitHub licenses for a user's repositories.
- Add script to join CSV files for customers and orders.
- Add customers and orders CSV files.
- Add SQL method examples for reading CSV and JSON files.
- Add `Out-DuckData` function to export data from reader.

### Updates:
- Refactor `New-DuckDBConnection.ps1`, add `sql` and `CloseDB` methods, and update module dependencies.

### Removals:
- Remove unused code and fix formatting in `Invoke-PSDuckDb.ps1`.

# 0.1.1

- add ordered to hashtable to keep order of column names
- dispose of reader and duckCommand

# 0.1.0

- Initial release

# https://www.pgrs.net/2024/03/21/duckdb-as-the-new-jq/

# Define a parameter for the script, allowing the user to specify a GitHub username
param(
  $user = 'dfinke'  # Default GitHub username if none is provided
)

Write-Host "GitHub Licenses for User: $($user) Repositories" -ForegroundColor Cyan

# Create a new DuckDB connection and execute a SQL query within a single command
(New-DuckDBConnection).sql(@"
select license->>'key' as license, count(*) as count              -- Select the license key and count occurrences
  from read_json('https://api.github.com/users/$($user)/repos')   -- Read JSON data directly from GitHub API
  group by 1                                                      -- Group the results by license key
  order by count desc                                             -- Order the results by count in descending order
"@)

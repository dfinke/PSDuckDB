function Out-DuckData {
    param($reader)

    while ($reader.read()) {
        # Create a hashtable for the current row
        $rowObject = [Ordered]@{}
        For ($columnIndex = 0; $columnIndex -lt $reader.FieldCount; $columnIndex++ ) {
            # Add field name and value as key-value pair
            $rowObject[$reader.GetName($columnIndex)] = $reader.GetValue($columnIndex)        
        }
    
        # Convert the hashtable to a custom object and add it to the array
        [PSCustomObject]$rowObject
    }
}

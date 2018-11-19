# Formats JSON in a nicer format than the built-in ConvertTo-Json does.
function Format-Json(
    [Parameter(Mandatory, ValueFromPipeline)]
    [String]
    $json) {
    $indent = 0;
    ($json -Split '\n' |
            ForEach-Object {
            if ($_ -match '[\}\]]') {
                # This line contains  ] or }, decrement the indentation level
                $indent--
            }
            $line = (' ' * $indent * 2) + $_.TrimStart().Replace(':  ', ': ')
            if ($_ -match '[\{\[]') {
                # This line contains [ or {, increment the indentation level
                $indent++
            }
            $line
        }) -Join "`n"
}
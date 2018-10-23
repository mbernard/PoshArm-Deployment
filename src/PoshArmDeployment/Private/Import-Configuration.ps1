function Import-Configuration {
    [cmdletbinding()]
    param(
        [string]
        $path,
        [Parameter(ValueFromPipeline)]
        [PSCustomObject]
        $baseConfig = [PSCustomObject]@{}
    )

    process {
        if (Test-Path $path) {
            return Get-Content $path | ConvertFrom-Json | Merge-Object $baseConfig
        }
        else {
            return $baseConfig
        }
    }
}
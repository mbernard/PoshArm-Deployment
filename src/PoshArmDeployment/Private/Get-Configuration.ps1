function Get-Configuration {
    [cmdletbinding()]
    param(
        [string]
        $ConfigurationFilePath,
        [Parameter(ValueFromPipeline)]
        [PSCustomObject]
        $BaseConfiguration = [PSCustomObject]@{}
    )

    process{
        if(Test-Path $ConfigurationFilePath)
        {
            return Get-Content $ConfigurationFilePath | ConvertFrom-Json | Merge-Object $BaseConfiguration
        }
        else
        {
            return $BaseConfiguration
        }
    }
}
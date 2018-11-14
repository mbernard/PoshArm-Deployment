function Get-Configuration {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $True)]
        [string]
        $ConfigurationFilePath,
        [Parameter(ValueFromPipeline)]
        [PSCustomObject]
        $BaseConfiguration = [PSCustomObject]@{}
    )

    process{
        Write-Debug "Loading configuration file '$ConfigurationFilePath'"
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
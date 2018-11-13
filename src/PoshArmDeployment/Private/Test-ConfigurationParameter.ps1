function Test-ConfigurationParameter {
    [cmdletbinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [PSCustomObject]
        $Configuration,
        [Parameter(Mandatory = $True)]
        [string]
        $ConfigurationParameterName,
        $DefaultValue
    )

    if ($Configuration.ConfigurationParameterName) {
        return $Configuration.ConfigurationParameterName
    }
    elseif ($DefaultValue) {
        return $DefaultValue
    }
    else {
        Write-Error "$ConfigurationParameterName is not defined in the configuration file\n$Configuration"
    }
}
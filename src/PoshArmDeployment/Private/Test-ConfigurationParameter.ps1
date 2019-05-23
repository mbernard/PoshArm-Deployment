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

    if ($Configuration."$ConfigurationParameterName") {
        return $Configuration."$ConfigurationParameterName"
    }
    elseif ($PSBoundParameters.ContainsKey('DefaultValue')) {
        return $DefaultValue
    }
    else {
        $jsonConfiguration = ConvertTo-Json $Configuration -Depth 99
        Write-Error "$ConfigurationParameterName is not defined in the configuration file $jsonConfiguration"
    }
}
function Initialize-Configuration {
    [cmdletbinding()]
    param(
        [ValidatePattern('^[a-z0-9-]*$')]
        [string]
        $EnvironmentCode = "dev",
        [string]
        $ConfigurationFileName = "ScriptConfiguration.json",
        [string]
        $ConfigurationPath = '.'
    )

    Process{
        $ErrorActionPreference = 'Stop'

        # 1. Load json configuration files
        $configuration = Get-EnvironmentConfiguration -EnvironmentCode $EnvironmentCode `
            -ConfigurationPath $ConfigurationPath `
            -ConfigurationFileName $ConfigurationFileName

        # 2. Load settings values in script scope
        $script:ProjectName = Test-ConfigurationParameter $configuration projectName
        $script:Location = Test-ConfigurationParameter $configuration location
        $script:EnvironmentCode = Test-ConfigurationParameter $configuration environmentCode
        $script:Context = Test-ConfigurationParameter $configuration context -DefaultValue ""
        $script:Version = $configuration | Test-ConfigurationParameter -ConfigurationParameterName version -DefaultValue "1.0"
        $script:Configuration = $configuration

        Write-Debug "Loaded all mandatory script parameters"

        return $configuration
    }
}
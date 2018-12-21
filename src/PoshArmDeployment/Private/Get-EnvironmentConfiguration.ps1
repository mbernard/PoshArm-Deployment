function Get-EnvironmentConfiguration {
    [cmdletbinding()]
    param(
        [ValidatePattern('^[a-z0-9-]*$')]
        [string]
        $EnvironmentCode = "dev",
        [string]
        $ConfigurationPath = $MyInvocation.PSScriptRoot,
        [string]
        $ConfigurationFileName = "ScriptConfiguration.json"
    )

    Process {
        $ErrorActionPreference = 'Stop'

        $fileNameWithoutExtension = [io.path]::GetFileNameWithoutExtension($ConfigurationFileName)
        $extension = [io.path]::GetExtension($ConfigurationFileName)

        $configuration = Get-Configuration (Join-Path $ConfigurationPath "$fileNameWithoutExtension$extension") `
            | Get-Configuration (Join-Path $ConfigurationPath "$fileNameWithoutExtension.$EnvironmentCode$extension")
            | Get-Configuration (Join-Path $ConfigurationPath "$fileNameWithoutExtension.$EnvironmentCode.override$extension")

        Write-Debug ('Loaded Configuration: {0}' -f ($configuration | ConvertTo-Json -Depth 100))

        return $configuration
    }
}
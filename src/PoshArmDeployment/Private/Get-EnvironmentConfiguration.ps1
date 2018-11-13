function Get-EnvironmentConfiguration {
    [cmdletbinding()]
    param(
        [ValidatePattern('^[a-z0-9-]*$')]
        [string]
        $EnvironmentCode = "dev",
        [string]
        $ConfigurationPath = '.\',
        [string]
        $ConfigurationFileName = "ScriptConfiguration.json"
    )

    Process {
        $ErrorActionPreference = 'Stop'

        $fileNameWithoutExtension = [io.path]::GetFileNameWithoutExtension($ConfigurationFileName)
        $extension = [io.path]::GetExtension($ConfigurationFileName)

        $configuration = Get-Setting Join-Path $ConfigurationPath "$fileNameWithoutExtension.$extension" `
            | Get-Setting Join-Path $ConfigurationPath "$fileNameWithoutExtension.$EnvironmentCode.$extension"

        Write-Debug ('Loaded Configuration: {0}' -f ($configuration | ConvertTo-Json -Depth 100))

        return $configuration
    }
}
#Requires -Version 5.0

function Get-SupportedResourceProviders {
    [cmdletbinding()]
    param()
    Begin {
        $ErrorActionPreference = 'Stop'
        $jsonFilePath = Join-Path $PSScriptRoot './SupportedResourceProviders.json'
    }

    Process {
        $result = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json

        if (-not $result) {
            throw 'Unable to load resource provider'
        }
        $result
    }
}
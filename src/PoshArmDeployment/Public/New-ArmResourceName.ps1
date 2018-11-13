#Requires -Version 5.0

function New-ArmResourceName {
    [CmdletBinding(DefaultParameterSetName = 'ForceVersion')]
    param(
        [string]
        $ProjectName = $script:projectName,
        [string]
        $EnvironmentCode = $script:environmentCode,
        [string]
        $Context = $script:context,
        [string]
        $Location = $script:location,
        [string]
        $ResourceName = 'default',
        [Parameter(ParameterSetName = "ForceVersion")]
        [string]
        $Version = $script:version,
        [Parameter(ParameterSetName = "IgnoreVersion")]
        [switch]
        $IgnoreVersionInHash
    )
    DynamicParam {
        Add-ResourceTypeDynamicParameter
    }
    Begin {
        $ResourceProvider = Get-SupportedResourceProviders | Where-Object resourceType -eq $PSBoundParameters['ResourceType']
    }
    Process {
        # $nameParts = @(
        #     $ProjectName
        #     $EnvironmentCode
        #     $Context
        #     $resourceProvider.shortName
        #     $ResourceName
        # ) | where {$_}

        $delimiter = switch ($ResourceProvider.resourceType) {
            'Microsoft.Storage/storageAccounts' {
                '0'
            }
            default {
                '-'
            }
        }

        $hashParts = @(
            $ProjectName
            $EnvironmentCode
            $Context
            $Location
            $ResourceProvider.shortName
            $ResourceName
            )
        if ((-not $IgnoreVersionInHash) -and $Version) {
            # If a version number is forced and IngnoreVersionInHash is not set
            # include it in hash
            $hashParts += $Version
        }

        # Remove any empty values
        $hashParts = $hashParts | Where-Object {$_} 
        $hashParts = [string]::Join(',', $hashParts)

        "concat('$ResourceName$delimiter', uniqueString($hashParts))"
    }
}
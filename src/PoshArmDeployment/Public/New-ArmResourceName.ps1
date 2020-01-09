#Requires -Version 5.0

function New-ArmResourceName {
    [CmdletBinding(DefaultParameterSetName = 'ForceVersion', SupportsShouldProcess = $True)]
    [OutputType([String])]
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
        $ResourceName,
        [Parameter(ParameterSetName = "ForceVersion")]
        [string]
        $Version = $script:version,
        [Parameter(ParameterSetName = "IgnoreVersion")]
        [switch]
        $IgnoreVersionInHash,
        [string]
        $NamingConvention = $script:ResourceNamingConvention
    )
    DynamicParam {
        Add-ResourceTypeDynamicParameter
    }
    Begin {
        $ResourceProvider = Get-SupportedResourceProvider | Where-Object resourceType -eq $PSBoundParameters['ResourceType']

        if (!$NamingConvention) {
            $NamingConvention = "{environmentcode}{delimiter}{resourcename}{delimiter}{hash}"
        }

        if(!$ResourceName){
            $ResourceName = $ResourceProvider.shortName
        }

        $Delimiter = switch ($ResourceProvider.resourceType) {
            'Microsoft.Storage/storageAccounts' {
                '0'
            }
            default {
                '-'
            }
        }
    }
    Process {
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
        $hashParts = $hashParts | Where-Object {$_.ToLowerInvariant()}
        $hashParts = [string]::Join(''',''', $hashParts)

        If ($PSCmdlet.ShouldProcess("Generating arm expression representig the resource name")) {
            $Name = $NamingConvention.ToLowerInvariant()
            $Name = "[concat('$Name')]"
            $Name = $Name.Replace("{delimiter}", $Delimiter)
            $Name = $Name.Replace("{projectname}", $ProjectName)
            $Name = $Name.Replace("{environmentcode}", $EnvironmentCode)
            $Name = $Name.Replace("{context}", $Context)
            $Name = $Name.Replace("{location}", $Location)
            $Name = $Name.Replace("{resourcename}", $ResourceName)
            $Name = $Name.Replace("{hash}", "', uniqueString('$hashParts'),'")

            # make sure we don't have 2 delimiter with nothing between them
            while ($Name.Contains("$Delimiter$Delimiter")){
                $Name = $Name.Replace("$Delimiter$Delimiter", $Delimiter)
            }

            return $Name.ToLowerInvariant()
        }
    }
}
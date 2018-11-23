function New-ArmParameter {
    [cmdletbinding(DefaultParameterSetName = "default")]
    Param(
        [Parameter(ParameterSetName = "keyVault")]
        [Parameter(Mandatory, ParameterSetName = "default")]
        [string]
        $Name,
        [Parameter(Mandatory, ParameterSetName = "default")]
        [ValidateSet("string", "securestring", "int", "bool", "object", "secureObject", "array")]
        [string]
        $Type,
        [Parameter(Mandatory, ParameterSetName = "default")]
        $Value,
        [Parameter(Mandatory, ParameterSetName = "keyVault")]
        [string]
        $KeyVaultResourceId,
        [Parameter(Mandatory, ParameterSetName = "keyVault")]
        [string]
        $SecretName
    )

    if ($PSCmdlet.ParameterSetName -eq "default") {
        $propHash = [ordered]@{
            type  = $Type
            value = $Value
        }
    }
    else {
        if (!$Name) {
            $Name = $SecretName
        }

        $propHash = [ordered]@{
            type = "securestring"
        }

        $script:ArmParameters.Add($Name, @{
                reference = @{
                    keyVault   = @{
                        id = $KeyVaultResourceId
                    }
                    secretName = $SecretName
                }
            })
    }

    $out = [PSCustomobject]@{
        PSTypeName = "ArmParameter"
        $Name      = [PSCustomobject]$propHash
        _Reference = "[parameters('$name')]"
    }

    $out
}
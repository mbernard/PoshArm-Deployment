function New-ArmKeyVaultSecretResource {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("KeyVaultSecret")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name,
        [string]
        $ApiVersion = '2016-10-01',
        [string]
        $Location = $script:Location,
        [Parameter(Mandatory)]
        [string]
        $KeyVaultName,
        [Parameter(Mandatory)]
        [string]
        $Value
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm KeyVault secret resource")) {
        $KeyVaultName = $KeyVaultName | ConvertTo-ValueInTemplateExpression

        $keyVaultSecret = [PSCustomObject][ordered]@{
            PSTypeName = "KeyVaultSecret"
            type       = 'Microsoft.KeyVault/vaults/secrets'
            name       = "[concat($KeyVaultName, '/$Name')]"
            apiVersion = $ApiVersion
            location   = $Location
            properties = @{
                value       = $Value
            }
            resources  = @()
            dependsOn  = @(
            )
        }

        $keyVaultSecret.PSTypeNames.Add("ArmResource")
        return $keyVaultSecret
    }
}
function New-ArmKeyVaultResource {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("KeyVault")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name,
        [string]
        $ApiVersion = '2016-10-01',
        [string]
        $Location = $script:Location,
        [ValidateSet('standard', 'premium')]
        [string]
        $SkuName = 'standard',
        [string]
        $SkuFamily = 'A',
        [string]
        $TenantId = '[subscription().tenantId]',
        [Switch]
        $EnabledForDeployment,
        [Switch]
        $EnabledForTemplateDeployment,
        [Switch]
        $EnabledForDiskEncryption
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm KeyVault object")) {
        $keyVault = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType 'Microsoft.KeyVault/vaults'
            PSTypeName  = "KeyVault"
            type        = 'Microsoft.KeyVault/vaults'
            name        = $Name
            apiVersion  = $ApiVersion
            location    = $Location
            properties  = @{
                sku                          = @{
                    name   = $SkuName
                    family = $SkuFamily
                }
                tenantId                     = $TenantId
                accessPolicies               = @()
                enabledForDeployment         = $EnabledForDeployment.ToBool()
                enabledForTemplateDeployment = $EnabledForTemplateDeployment.ToBool()
                enabledForDiskEncryption     = $EnabledForDiskEncryption.ToBool()
            }
            resources   = @()
            dependsOn   = @()
        }

        $keyVault.PSTypeNames.Add("ArmResource")
        return $keyVault
    }
}
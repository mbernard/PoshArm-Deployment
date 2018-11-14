function New-ArmKeyVaultResource {
    [CmdletBinding()]
    [OutputType([hashtable])]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^[a-zA-Z0-9-]*$')]
        [string]
        $Name,
        [string]
        $ApiVersion = '2016-10-01',
        [string]
        $Location = $script:Location,
        [ValidateSet('Standard', 'Premium')]
        [string]
        $SkuName = 'Standard',
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

    return [PSCustomObject][ordered]@{
        _ResourceId = New-ArmFunctionResourceId -ResourceType 'Microsoft.KeyVault/vaults' $Name
        type = 'Microsoft.KeyVault/vaults'
        name = $Name
        apiVersion = $ApiVersion
        location = $Location
        properties = @{
            sku = @{
                name = $SkuName
                family = $SkuFamily
            }
            tenantId = $TenantId
            accessPolicies = @()
            enabledForDeployment = $EnabledForDeployment.ToBool()
            enabledForTemplateDeployment = $EnabledForTemplateDeployment.ToBool()
            enabledForDiskEncryption = $EnabledForDiskEncryption.ToBool()
        }
        resources = @()
        dependsOn = @()
    }
}
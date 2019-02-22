function New-ArmPublicIpResource {
    [CmdletBinding(SupportsShouldProcess = $True)]
    [OutputType("PublicIp")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name,
        [string]
        $ApiVersion = "2017-08-01",
        [string]
        $Location = $script:Location,
        [string]
        $DomainNameLabel,
        [string]
        [ValidateSet("Basic", "Standard")]
        $Sku = "Standard",
        [string]
        [ValidateSet("Dynamic", "Static")]
        $PublicIPAllocationMethod = "Static"
    )
    If ($PSCmdlet.ShouldProcess("Creates a new Arm public ip resource")) {
        if (!$DomainNameLabel) {
            $DomainNameLabel = $Name
        }

        $PublicIp = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType Microsoft.Network/publicIPAddresses
            PSTypeName  = "PublicIp"
            type        = 'Microsoft.Network/publicIPAddresses'
            name        = $Name
            apiVersion  = $ApiVersion
            location    = $Location
            sku         = @{
                name = $Sku
                tier = "Regional"
            }
            properties  = @{
                publicIPAllocationMethod = $PublicIPAllocationMethod
                dnsSettings              = @{
                    domainNameLabel = $DomainNameLabel
                }
            }
            resources   = @()
            dependsOn   = @()
        }

        $PublicIp.PSTypeNames.Add("ArmResource")
        return $PublicIp
    }
}
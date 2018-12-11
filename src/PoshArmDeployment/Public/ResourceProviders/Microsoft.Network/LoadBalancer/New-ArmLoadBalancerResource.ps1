function New-ArmLoadBalancerResource {
    [CmdletBinding(SupportsShouldProcess = $True)]
    [OutputType("LoadBalancer")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name,
        [string]
        $ApiVersion = "2018-02-01",
        [string]
        $Location = $script:location,
        [string]
        [ValidateSet("Basic", "Standard")]
        $Sku = "Standard"
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm load balancer resource")) {
        $LoadBalancer = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType Microsoft.Network/loadBalancers
            PSTypeName  = "LoadBalancer"
            type        = 'Microsoft.Network/loadBalancers'
            name        = $Name
            apiVersion  = $ApiVersion
            location    = $Location
            sku         = @{
                name = $Sku
                tier = "Regional"
            }
            properties  = @{
                frontendIPConfigurations = @()
                backendAddressPools      = @()
                inboundNatPools          = @()
                # inboundNatRules          = @()
                loadBalancingRules       = @()
                probes                   = @()
            }
            resources   = @()
            dependsOn   = @()
        }

        $LoadBalancer.PSTypeNames.Add("ArmResource")
        return $LoadBalancer
    }
}
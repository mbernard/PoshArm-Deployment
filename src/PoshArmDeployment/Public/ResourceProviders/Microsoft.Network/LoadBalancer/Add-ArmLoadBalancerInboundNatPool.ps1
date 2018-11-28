function Add-ArmLoadBalancerInboundNatPool {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("LoadBalancer")]
    Param(
        [PSTypeName("LoadBalancer")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $LoadBalancer,
        [string]
        [Parameter(Mandatory)]
        $Name,
        [int]
        [Parameter(Mandatory)]
        $BackendPort,
        [int]
        [Parameter(Mandatory)]
        $FrontendPortRangeStart,
        [int]
        [Parameter(Mandatory)]
        $FrontendPortRangeEnd,
        [string]
        [ValidateSet("Tcp", "Udp", "All")]
        $Protocol = "Tcp",
        [string]
        $FrontEndIpConfigurationName
    )

    if (!$FrontendIpConfigurationName) {
        $FrontendIpConfigurationName = $LoadBalancer.properties.frontendIPConfigurations[0].Name
    }

    If ($PSCmdlet.ShouldProcess("Adding inbound nat pool")) {
        $LoadBalancerResourceId = $LoadBalancer._ResourceId

        $InboundNatPool = @{
            name       = $Name
            properties = @{
                backendPort             = $BackendPort
                frontendIPConfiguration = @{
                    id = "[concat($LoadBalancerResourceId, '/frontendIPConfigurations/', '$FrontendIpConfigurationName')]"
                }
                frontendPortRangeEnd    = $FrontendPortRangeEnd
                frontendPortRangeStart  = $FrontendPortRangeStart
                protocol                = $Protocol
            }
        }

        $LoadBalancer.properties.inboundNatPools += $InboundNatPool

        return $LoadBalancer
    }
}
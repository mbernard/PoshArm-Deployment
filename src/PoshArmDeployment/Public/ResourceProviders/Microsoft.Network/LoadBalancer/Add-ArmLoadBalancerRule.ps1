function Add-ArmLoadBalancerRule {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("LoadBalancer")]
    Param(
        [PSTypeName("LoadBalancer")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $LoadBalancer,
        [string]
        $Name = "default",
        [string]
        $BackendAddressPoolName,
        [int]
        [Parameter(Mandatory)]
        $FrontendPort,
        [int]
        $BackendPort = $FrontendPort,
        [string]
        $FrontendIpConfigurationName,
        [int]
        $IdleTimeoutInMinutes = 5,
        [string]
        $ProbeName,
        [string]
        [ValidateSet("Tcp", "Udp", "All")]
        $Protocol = "Tcp"
    )

    if (!$BackendAddressPoolName) {
        $BackendAddressPoolName = $LoadBalancer.properties.backendAddressPools[0].Name
    }

    if (!$FrontendIpConfigurationName) {
        $FrontendIpConfigurationName = $LoadBalancer.properties.frontendIPConfigurations[0].Name
    }
    if (!$ProbeName) {
        $ProbeName = $LoadBalancer.properties.probes[0].Name
    }

    If ($PSCmdlet.ShouldProcess("Adding load balancing rule")) {
        $LoadBalancerResourceId = $LoadBalancer._ResourceId

        $Rule = [PSCustomObject][Ordered]@{
            name       = $Name
            properties = @{
                backendAddressPool      = @{
                    id = "[concat($LoadBalancerResourceId, '/backendAddressPools/$BackendAddressPoolName')]"
                }
                backendPort             = $BackendPort
                frontendIPConfiguration = @{
                    id = "[concat($LoadBalancerResourceId, '/frontendIPConfigurations/', '$FrontendIpConfigurationName')]"
                }
                frontendPort            = $FrontendPort
                idleTimeoutInMinutes    = $IdleTimeoutInMinutes
                probe                   = @{
                    id = "[concat($LoadBalancerResourceId, '/probes/', '$ProbeName')]"
                }
                protocol                = $Protocol
                enableFloatingIP        = $false
            }
        }

        $LoadBalancer.properties.loadBalancingRules += $Rule

        return $LoadBalancer
    }
}
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
        [ValidateSet("tcp", "http")]
        $Protocol = "tcp",
        [Parameter(Mandatory)]
        [PSTypeName("LoadBalancerFrontEndIpConfiguration")]
        $FrontEndIpConfiguration
    )

    If ($PSCmdlet.ShouldProcess("Adding inbound nat pool")) {
        $InboundNatPool = @{
            name        = $Name
            properties = @{
                backendPort = $BackendPort
                frontendIPConfiguration = @{
                    id = $FrontEndIpConfiguration._ResourceId
                }
                frontendPortRangeEnd = $FrontendPortRangeEnd
                frontendPortRangeStart = $FrontendPortRangeStart
                protocol = $Protocol
            }
        }

        $LoadBalancer.properties.inboundNatPools += $InboundNatPool

        return $LoadBalancer
    }
}
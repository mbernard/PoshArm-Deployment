function Add-ArmLoadBalancerBackendAddressPool {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("LoadBalancer")]
    Param(
        [PSTypeName("LoadBalancer")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $LoadBalancer,
        [string]
        $Name = "default"
    )

    If ($PSCmdlet.ShouldProcess("Adding backend pool")) {
        $LoadBalancerResourceId = $LoadBalancer._ResourceId
        $backendPool = @{
            _ResourceId = "[concat($LoadBalancerResourceId, '/backendAddressPools/$Name')]"
            name        = $Name
        }

        $LoadBalancer.properties.backendAddressPools += $backendPool

        return $LoadBalancer
    }
}
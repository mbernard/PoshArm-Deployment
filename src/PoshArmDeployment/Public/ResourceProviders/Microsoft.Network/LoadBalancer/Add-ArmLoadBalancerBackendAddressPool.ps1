function Add-ArmLoadBalancerBackendAddressPool {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("LoadBalancer")]
    Param(
        [PSTypeName("LoadBalancer")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $LoadBalancer,
        [string]
        [Parameter(Mandatory)]
        $Name,
        [Parameter(Mandatory)]
        [PSTypeName("NetworkInterfaceConfiguration")]
        $Nic
    )

    If ($PSCmdlet.ShouldProcess("Adding backend pool")) {
        $LoadBalancerResourceId = $LoadBalancer._ResourceId
        $backendPool = @{
            _ResourceId = "[concat($LoadBalancerResourceId, '/backendAddressPools/$Name')]"
            name        = $Name
        }

        $LoadBalancer.properties.backendAddressPools += $backendPool
        $Nic.properties.ipConfigurations[0].properties.loadBalancerBackendAddressPools += @{
            id = $backendPool._ResourceId
        }

        return $LoadBalancer
    }
}
function Add-ArmNicLoadBalancer {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = "vm")]
    Param(
        [PSTypeName("Nic")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $Nic,
        [PSTypeName("LoadBalancer")]
        [Parameter(Mandatory)]
        $LoadBalancer,
        [string]
        $BackendAddressPoolName,
        [string]
        $InboundNatPoolName
    )

    if (!$BackendAddressPoolName) {
        $BackendAddressPoolName = $LoadBalancer.properties.backendAddressPools[0].Name
    }

    if (!$InboundNatPoolName) {
        $InboundNatPoolName = $LoadBalancer.properties.inboundNatPools[0].Name
    }

    If ($PSCmdlet.ShouldProcess("Adding Nic to load balancer")) {
        $LoadBalancerResourceId = $LoadBalancer._ResourceId

        $Nic.properties.ipConfigurations[0].properties.loadBalancerBackendAddressPools += @{
            id = "[concat($LoadBalancerResourceId, '/backendAddressPools/$BackendAddressPoolName')]"
        }

        $Nic.properties.ipConfigurations[0].properties.loadBalancerInboundNatPools += @{
            id = "[concat($LoadBalancerResourceId, '/inboundNatPools/$InboundNatPoolName')]"
        }
    }

    return $Nic
}
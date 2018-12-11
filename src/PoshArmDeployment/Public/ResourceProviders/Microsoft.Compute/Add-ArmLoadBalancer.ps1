function Add-ArmLoadBalancer {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("VirtualMachineScaleSet")]
    Param(
        [PSTypeName("VirtualMachineScaleSet")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $VirtualMachineScaleSet,
        [string]
        $NicName,
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

    if (!$NicName) {
        $NicName = $VirtualMachineScaleSet.properties.virtualMachineProfile.networkProfile.networkInterfaceConfigurations[0].Name
    }

    $Nic = $VirtualMachineScaleSet.properties.virtualMachineProfile.networkProfile.networkInterfaceConfigurations | Where-Object { $_.Name -eq $NicName}


    If ($PSCmdlet.ShouldProcess("Adding Nic to load balancer")) {
        $LoadBalancerResourceId = $LoadBalancer._ResourceId

        $Nic.properties.ipConfigurations[0].properties.loadBalancerBackendAddressPools += @{
            id = "[concat($LoadBalancerResourceId, '/backendAddressPools/$BackendAddressPoolName')]"
        }

        $Nic.properties.ipConfigurations[0].properties.loadBalancerInboundNatPools += @{
            id = "[concat($LoadBalancerResourceId, '/inboundNatPools/$InboundNatPoolName')]"
        }
    }

    return $VirtualMachineScaleSet | Add-ArmDependencyOn -Dependency $LoadBalancer
}
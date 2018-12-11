function Add-ArmApplicationGateway {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("VirtualMachineScaleSet")]
    Param(
        [PSTypeName("VirtualMachineScaleSet")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $VirtualMachineScaleSet,
        [string]
        $NicName,
        [PSTypeName("ApplicationGateway")]
        [Parameter(Mandatory)]
        $ApplicationGateway,
        [string]
        $BackendAddressPoolName
    )

    if (!$BackendAddressPoolName) {
        $BackendAddressPoolName = $ApplicationGateway.properties.backendAddressPools[0].Name
    }

    if (!$NicName) {
        $NicName = $VirtualMachineScaleSet.properties.virtualMachineProfile.networkProfile.networkInterfaceConfigurations[0].Name
    }

    $Nic = $VirtualMachineScaleSet.properties.virtualMachineProfile.networkProfile.networkInterfaceConfigurations | Where-Object { $_.Name -eq $NicName}

    If ($PSCmdlet.ShouldProcess("Adding Nic to Application gateway")) {
        $ApplicationGatewayResourceId = $ApplicationGateway._ResourceId

        $Nic.properties.ipConfigurations[0].properties.ApplicationGatewayBackendAddressPools += @{
            id = "[concat($ApplicationGatewayResourceId, '/backendAddressPools/$BackendAddressPoolName')]"
        }
    }

    return $VirtualMachineScaleSet | Add-ArmDependencyOn -Dependency $ApplicationGateway
}
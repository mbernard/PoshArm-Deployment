function Add-ArmVirtualNetworkSubnet {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("VirtualNetwork")]
    Param(
        [PSTypeName("VirtualNetwork")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $VirtualNetwork,
        [Parameter(Mandatory)]
        [PSTypeName("Subnet")]
        $Subnet
    )

    If ($PSCmdlet.ShouldProcess("Adding subnet to a virtual network")) {
        if ($Subnet._VirtualNetwork) {
            $subnetName = $Subnet.Name
            $vnetName = $VirtualNetwork.Name
            Write-Error "Subnet $subnetName is already linked to a virtual network named $vnetName"
        }
        else {
            $Subnet._VirtualNetwork = $VirtualNetwork
            $Subnet._ResourceId = New-ArmFunctionResourceId -ResourceType Microsoft.Network/virtualNetworks/subnets -ResourceName1 $VirtualNetwork.Name -ResourceName2 $Subnet.Name
            $VirtualNetwork.properties.subnets += $Subnet
        }

        return $VirtualNetwork
    }
}
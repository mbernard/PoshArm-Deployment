function Add-ArmVirtualNetworkSubnet {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("VirtualNetwork")]
    Param(
        [PSTypeName("VirtualNetwork")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $VirtualNetwork,
        [Parameter(Mandatory)]
        [PSTypeName("VirtualNetworkSubnet")]
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
            $VirtualNetwork.properties.subnets += $Subnet
        }

        return $VirtualNetwork
    }
}
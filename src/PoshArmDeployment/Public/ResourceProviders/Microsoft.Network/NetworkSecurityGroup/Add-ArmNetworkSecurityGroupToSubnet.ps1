function Add-ArmNetworkSecurityGroupToSubnet {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("NSG")]
    Param(
        [PSTypeName("NSG")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $NSG,
        [Parameter(Mandatory)]
        [PSTypeName("Subnet")]
        $Subnet
    )

    If ($PSCmdlet.ShouldProcess("Adding NSG to a subnet")) {
        $vnet = $Subnet._VirtualNetwork
        $NsgResourceId = $NSG._ResourceId
        $Subnet.properties.networkSecurityGroup = @{
            id = "$NsgResourceId"
        }

        $vnet = $vnet | Add-ArmDependencyOn -Dependency $NSG

        return $NSG
    }
}
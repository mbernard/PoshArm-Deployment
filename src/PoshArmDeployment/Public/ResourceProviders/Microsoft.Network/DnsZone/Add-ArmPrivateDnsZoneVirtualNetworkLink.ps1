function Add-ArmPrivateDnsZoneVirtualNetworkLink {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("PDNSZ")]
    Param(
        [PSTypeName("PDNSZ")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $PrivateDnsZone,
        [PSTypeName("VirtualNetwork")]
        [Parameter(Mandatory)]
        $VirtualNetwork,
        [switch]
        $RegistrationEnabled,
        [string]
        $ApiVersion = "2018-09-01"
    )

    If ($PSCmdlet.ShouldProcess("Adding private DNS zone virtual network link")) {
        $ResourceType = "Microsoft.Network/privateDnsZones/virtualNetworkLinks"
        $PrivateDnsZoneName = $PrivateDnsZone.name
        $VirtualNetworkName = $VirtualNetwork.name
        $VNetLink = [PSCustomObject][ordered]@{
            _ResourceId = New-ArmFunctionResourceId -ResourceType $ResourceType -ResourceName1 $PrivateDnsZoneName
            PSTypeName  = "PDNSZVirtualNetworkLink"
            type        = $ResourceType
            name        = "[concat('$PrivateDnsZoneName/', $VirtualNetworkName)]"
            location    = $PrivateDnsZone.location
            apiVersion  = $ApiVersion
            properties  = @{
                registrationEnabled = $RegistrationEnabled.ToBool()
                virtualNetwork      = @{
                    id = $VirtualNetwork._ResourceId
                }
            }
            dependsOn   = @()
        }

        $VNetLink.PSTypeNames.Add("ArmResource")
        $VNetLink | Add-ArmDependencyOn -Dependency $VirtualNetwork -PassThru `
        | Add-ArmDependencyOn -Dependency $PrivateDnsZone -PassThru `
        | Add-ArmResource

        return $PrivateDnsZone
    }
}

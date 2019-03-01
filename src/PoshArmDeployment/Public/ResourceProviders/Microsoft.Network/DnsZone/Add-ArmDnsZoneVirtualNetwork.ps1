function Add-ArmDnsZoneVirtualNetwork {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("DNSZ")]
    Param(
        [PSTypeName("DNSZ")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $DNSZ,
        [string]
        [ValidateSet("Registration", "Resolution")]
        $IntegrationType = "Resolution",
        [Parameter(Mandatory)]
        [PSTypeName("VirtualNetwork")]
        $VirtualNetwork
    )

    If ($PSCmdlet.ShouldProcess("Adding DNS zone virtual network integration")) {
        $networkEntry = @{
            id = $VirtualNetwork._ResourceId
        }

        If ($IntegrationType -eq "Resolution") {
            $DNSZ.properties.resolutionVirtualNetworks += $networkEntry
        }
        else {
            $DNSZ.properties.registrationVirtualNetworks += $networkEntry
        }

        return $DNSZ | Add-ArmDependencyOn -Dependency $VirtualNetwork -PassThru
    }
}
function Add-ArmNetworkSecurityGroupSecurityRule {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("NSG")]
    Param(
        [PSTypeName("NSG")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $NSG,
        [string]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [Parameter(Mandatory)]
        $Name,
        [string]
        [ValidateSet("*", "Tcp", "Udp")]
        $Protocol = "*",
        [string]
        $SourcePortRange = "*",
        [string]
        $DestinationPortRange = "*",
        [string]
        $SourceAddressPrefix = "*",
        [string]
        $DestinationAddressPrefix= "*",
        [string]
        [ValidateSet("Allow", "Deny")]
        $Action = "Allow",
        [int]
        $Priority = 100,
        [string]
        [ValidateSet("Inbound", "Outbound")]
        $Direction = "Inbound",
        [string]
        $Description
    )

    If ($PSCmdlet.ShouldProcess("Adding NSG security rule")) {
        $rule = @{
            name = $Name
            properties = @{
                description = $Description
                protocol = $Protocol
                sourcePortRange = $SourcePortRange
                destinationPortRange = $DestinationPortRange
                sourceAddressPrefix = $SourceAddressPrefix
                destinationAddressPrefix = $DestinationAddressPrefix
                access = $Action
                priority = $Priority
                direction = $Direction
                sourcePortRanges = @()
                destinationPortRanges = @()
                sourceAddressPrefixes = @()
                destinationAddressPrefixes = @()
            }
        }

        $NSG.properties.securityRules += $rule

        return $NSG
    }
}
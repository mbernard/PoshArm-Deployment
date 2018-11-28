function New-ArmVirtualNetworkSubnet {
    [CmdletBinding(SupportsShouldProcess = $True)]
    [OutputType("Subnet")]
    Param(
        [Parameter(ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name = "default",
        [string]
        [ValidatePattern('^(?:[0-9]{1,3}\.){3}[0-9]{1,3}\/[0-9]{1,2}$')]
        $AddressPrefix = "10.0.0.0/24"
    )
    If ($PSCmdlet.ShouldProcess("Creates a new Arm Virtual Network subnet object")) {
        return [PSCustomObject][ordered]@{
            _ResourceId = ""
            _VirtualNetwork = $null
            PSTypeName  = "Subnet"
            name        = $Name
            properties  = @{
                addressPrefix = $AddressPrefix
            }
        }
    }
}
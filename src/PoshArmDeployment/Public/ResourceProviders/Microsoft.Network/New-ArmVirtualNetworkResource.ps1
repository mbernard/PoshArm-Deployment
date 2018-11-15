function New-ArmVirtualNetworkResource {
    [CmdletBinding(SupportsShouldProcess = $True)]
    [OutputType([VirtualNetwork])]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^[a-zA-Z0-9-]*$')]
        [string]
        $Name,
        [string]
        $ApiVersion = "2018-08-01",
        [string]
        $Location = $script:Location,
        [string]
        [ValidatePattern('^(?:[0-9]{1,3}\.){3}[0-9]{1,3}\/[0-9]{1,2}$')]
        $AddressSpace = "10.0.0.0/16"
    )
    If ($PSCmdlet.ShouldProcess("Creates a new Arm Virtual Network object")) {
        $vnet = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType Microsoft.Network/virtualNetworks
            PSTypeName  = "VirtualNetwork"
            type        = 'Microsoft.Network/virtualNetworks'
            name        = $Name
            apiVersion  = $ApiVersion
            location    = $Location
            properties  = @{
                addressSpace = @{
                    addressPrefixes = @(
                        $AddressSpace
                    )
                }
                subnets      = @()
            }
            resources   = @()
            dependsOn   = @()
        }

        $vnet.PSTypeNames.Add("ArmResource")
        return $vnet
    }
}
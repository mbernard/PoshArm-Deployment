function New-ArmNetworkSecurityGroupResource {
    [CmdletBinding(SupportsShouldProcess = $True)]
    [OutputType("NSG")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name,
        [string]
        $ApiVersion = "2018-08-01",
        [string]
        $Location = $script:Location
    )
    If ($PSCmdlet.ShouldProcess("Creates a new Arm NSG object")) {
        $nsg = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType Microsoft.Network/networkSecurityGroups
            PSTypeName  = "NSG"
            type        = 'Microsoft.Network/networkSecurityGroups'
            name        = $Name
            apiVersion  = $ApiVersion
            location    = $Location
            properties  = @{
                securityRules = @()
            }
            resources   = @()
            dependsOn   = @()
        }

        $nsg.PSTypeNames.Add("ArmResource")
        return $nsg
    }
}
function New-ArmPublicIpResource {
    [CmdletBinding(SupportsShouldProcess = $True)]
    [OutputType("PublicIp")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name,
        [string]
        $ApiVersion = "2017-06-01",
        [string]
        $Location = $script:Location
    )
    If ($PSCmdlet.ShouldProcess("Creates a new Arm public ip resource")) {
        $PublicIp = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType Microsoft.Network/publicIPAddresses
            PSTypeName  = "PublicIp"
            type        = 'Microsoft.Network/publicIPAddresses'
            name        = $Name
            apiVersion  = $ApiVersion
            location    = $Location
            properties  = @{
                publicIPAllocationMethod = "Dynamic"
            }
            resources   = @()
            dependsOn   = @()
        }

        $PublicIp.PSTypeNames.Add("ArmResource")
        return $PublicIp
    }
}
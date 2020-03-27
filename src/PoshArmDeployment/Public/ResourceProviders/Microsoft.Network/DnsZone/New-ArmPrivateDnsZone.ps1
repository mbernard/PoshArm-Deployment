function New-ArmPrivateDnsZone {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("PDNSZ")]
    Param(
        [string]
        [ValidatePattern('^(\[.*\])|(([a-z0-9-_]{1,127}\.)+([a-z]{2,3}))$')]
        [Parameter(Mandatory, ValueFromPipeline)]
        $Name,
        [string]
        $ApiVersion = "2018-09-01"
    )

    If ($PSCmdlet.ShouldProcess("Adding Private DNS zone")) {
        $ResourceType = "Microsoft.Network/privateDnsZones"
        $privateDnsZone = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType $ResourceType
            PSTypeName  = "PDNSZ"
            type        = $ResourceType
            name        = $Name
            apiVersion  = $ApiVersion
            location    = 'global'
            properties  = @{}
            dependsOn   = @()
        }

        $privateDnsZone.PSTypeNames.Add("ArmResource")
        return $privateDnsZone
    }
}

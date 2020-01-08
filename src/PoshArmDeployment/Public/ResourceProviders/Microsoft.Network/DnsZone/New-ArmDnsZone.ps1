function New-ArmDnsZone {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("DNSZ")]
    Param(
        [string]
        [ValidatePattern('^(\[.*\])|(([a-z0-9-_]{1,127}\.)+([a-z]{2,3}))$')]
        [Parameter(Mandatory, ValueFromPipeline)]
        $Name,
        [string]
        $ApiVersion = "2018-05-01"
    )

    If ($PSCmdlet.ShouldProcess("Adding DNS zone")) {
        $dnsZone = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType Microsoft.Network/dnszones
            PSTypeName  = "DNSZ"
            type        = 'Microsoft.Network/dnszones'
            name        = $Name
            apiVersion  = $ApiVersion
            location    = 'global'
            properties  = @{
                zoneType                    = "Public"
                registrationVirtualNetworks = @()
                resolutionVirtualNetworks   = @()
            }
            dependsOn   = @()
        }

        $dnsZone.PSTypeNames.Add("ArmResource")
        return $dnsZone
    }
}

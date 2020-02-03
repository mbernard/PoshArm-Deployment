function Add-ArmDnsZoneARecord {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("DNSZ")]
    Param(
        [PSTypeName("DNSZ")]
        [Parameter(Mandatory)]
        $DnsZone,
        [string]
        [ValidatePattern('^(\[.*\])|(([*@]\.)?[a-z0-9-\.]{1,127})$')]
        [Parameter(Mandatory, ValueFromPipeline)]
        $Name,
        [int]
        $TTL = 3600,
        [string[]]
        [Parameter(Mandatory)]
        $IpV4Addresses
    )

    If ($PSCmdlet.ShouldProcess("Adding DNS zone A record")) {
        $dnsZoneName = $DnsZone.name
        $aRecord = [PSCustomObject][ordered]@{
            _ResourceId = New-ArmFunctionResourceId -ResourceType Microsoft.Network/dnszones/A -ResourceName1 $dnsZoneName -ResourceName2 $Name
            PSTypeName  = "DNSZARecord"
            type        = 'Microsoft.Network/dnszones/A'
            name        = "[concat('$dnsZoneName', '/', '$Name')]"
            apiVersion  = $DnsZone.apiVersion
            properties  = @{
                TTL      = $TTL
                ARecords = @()
            }
            dependsOn   = @()
        }

        foreach ($IpV4Address in $IpV4Addresses) {
            $aRecord.properties.ARecords += @{
                ipv4Address = $IpV4Address
            }
        }

        $aRecord.PSTypeNames.Add("ArmResource")
        $aRecord | Add-ArmDependencyOn -Dependency $DnsZone `
        | Add-ArmResource
         
        return $DnsZone
    }
}

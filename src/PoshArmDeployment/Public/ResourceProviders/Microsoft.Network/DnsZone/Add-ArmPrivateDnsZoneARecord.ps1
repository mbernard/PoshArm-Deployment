function Add-ArmPrivateDnsZoneARecord {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("PDNSZ")]
    Param(   
        [PSTypeName("PDNSZ")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $PrivateDnsZone,
        [string]
        [ValidatePattern('^(\[.*\])|(([*@]\.)?[a-z0-9-\.]{1,127})$')]
        [Parameter(Mandatory)]
        $Name, 
        [int]
        $TTL = 3600,
        [string[]]
        [Parameter(Mandatory)]
        $IpV4Addresses
    )

    If ($PSCmdlet.ShouldProcess("Adding private DNS zone A record")) {
        $ResourceType = "Microsoft.Network/privateDnsZones/A"
        $PrivateDnsZoneName = $PrivateDnsZone.name
        $aRecord = [PSCustomObject][ordered]@{
            _ResourceId = New-ArmFunctionResourceId -ResourceType $ResourceType -ResourceName1 $PrivateDnsZoneName -ResourceName2 $Name
            PSTypeName  = "PDNSZARecord"
            type        = $ResourceType
            name        = "[concat('$PrivateDnsZoneName', '/', '$Name')]"
            apiVersion  = $PrivateDnsZone.apiVersion
            properties  = @{
                ttl      = $TTL
                aRecords = @()
            }
            dependsOn   = @()
        }

        foreach ($IpV4Address in $IpV4Addresses) {
            $aRecord.properties.aRecords += @{
                ipv4Address = $IpV4Address
            }
        }

        $aRecord.PSTypeNames.Add("ArmResource")
        $aRecord | Add-ArmDependencyOn -Dependency $PrivateDnsZone -PassThru `
        | Add-ArmResource

        return $PrivateDnsZone
    }
}

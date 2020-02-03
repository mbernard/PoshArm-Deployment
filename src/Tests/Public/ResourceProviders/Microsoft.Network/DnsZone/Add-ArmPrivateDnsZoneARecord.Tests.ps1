$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
    Describe "Add-ArmPrivateDnsZoneARecord" {
        
        $ResourceType = "Microsoft.Network/privateDnsZones/A"
        $ZoneName = "contoso.com"
        $ExpectedARecordName = "resource"

        $ExpectedPrivateDnsZone = $ZoneName | New-ArmPrivateDnsZone
        $IpV4Addresses = @("address1", "address2")

        Context "Unit tests" {

            $Depth = 3
            $expectedTypes = @("PDNSZARecord", "ArmResource")

            It "Given the required parameters, it returns '<Expected>'" -TestCases @(
                @{  Name           = $ExpectedARecordName
                    PrivateDnsZone = $ExpectedPrivateDnsZone
                    IpV4Addresses  = $IpV4Addresses
                    Expected       = [PSCustomObject][ordered]@{
                        _ResourceId = New-ArmFunctionResourceId -ResourceType $ResourceType -ResourceName1 $ZoneName -ResourceName2 $ExpectedARecordName
                        PSTypeName  = "PDNSZARecord"
                        type        = $ResourceType
                        name        = "[concat('$ZoneName', '/', '$ExpectedARecordName')]"
                        apiVersion  = $ExpectedPrivateDnsZone.apiVersion
                        properties  = @{
                            ttl      = 3600
                            aRecords = @()
                        }
                        dependsOn   = @($ExpectedPrivateDnsZone._ResourceId)
                    }
                    Types          = $expectedTypes
                }
            ) {
                param($Name, $PrivateDnsZone, $IpV4Addresses, $Expected, $Types)

                foreach ($IpV4Address in $IpV4Addresses) {
                    $Expected.properties.ARecords += @{
                        ipv4Address = $IpV4Address
                    }
                }
                $Expected.PSTypeNames.Add("ArmResource")

                New-ArmTemplate

                $PrivateDnsZone | Add-ArmPrivateDnsZoneARecord -Name $Name -IpV4Addresses $IpV4Addresses

                $actual = $ArmTemplate.resources[0]

                ($actual | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                | Should -BeExactly ($Expected | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })

                $Types | ForEach-Object { $actual.PSTypeNames | Should -Contain $_ }
            }
        }

        Context "Integration tests" {
            It "Default" -Test {
                Invoke-IntegrationTest -ArmResourcesScriptBlock `
                {
                    $ZoneName | New-ArmPrivateDnsZone `
                    | Add-ArmPrivateDnsZoneARecord `
                        -Name $ExpectedARecordName `
                        -IpV4Addresses $IpV4Addresses `
                    | Add-ArmResource
                }
            }

            It "Explicit Parameters" -Test {
                Invoke-IntegrationTest -ArmResourcesScriptBlock `
                {
                    $ZoneName | New-ArmPrivateDnsZone `
                    | Add-ArmPrivateDnsZoneARecord `
                        -Name $ExpectedARecordName `
                        -IpV4Addresses $IpV4Addresses `
                        -TTL 400 `
                    | Add-ArmResource
                }
            }
        }
    }
}

$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
    Describe "Add-ArmPrivateDnsZoneVirtualNetworkLink" {
        
        $ResourceType = "Microsoft.Network/privateDnsZones/virtualNetworkLinks"
        $ExpectedPrivateDnsZoneName = "contoso.com"
        $ExpectedVirtualNetworkName = New-ArmResourceName -ResourceType Microsoft.Network/virtualNetworks

        $ExpectedVirtualNetwork = $ExpectedVirtualNetworkName | New-ArmVirtualNetworkResource
        $ExpectedPrivateDnsZone = $ExpectedPrivateDnsZoneName | New-ArmPrivateDnsZone
        
        Context "Unit tests" {

            $Depth = 3
            $expectedTypes = @("PDNSZVirtualNetworkLink", "ArmResource")

            It "Given the required parameters, it returns '<Expected>'" -TestCases @(
                @{  PrivateDnsZone = $ExpectedPrivateDnsZone
                    VirtualNetwork = $ExpectedVirtualNetwork
                    Expected       = [PSCustomObject][ordered]@{
                        _ResourceId = New-ArmFunctionResourceId -ResourceType $ResourceType -ResourceName1 $ExpectedPrivateDnsZoneName
                        PSTypeName  = "PDNSZVirtualNetworkLink"
                        type        = $ResourceType
                        name        = "[concat('$ExpectedPrivateDnsZoneName/', $ExpectedVirtualNetworkName)]"
                        location    = "global"
                        apiVersion  = "2018-09-01"
                        properties  = @{
                            registrationEnabled = $false
                            virtualNetwork      = @{
                                id = $ExpectedVirtualNetwork._ResourceId
                            }
                        }
                        dependsOn   = @($ExpectedVirtualNetwork._ResourceId, $ExpectedPrivateDnsZone._ResourceId)
                    }
                    Types          = $expectedTypes
                }
            ) {
                param($PrivateDnsZone, $VirtualNetwork, $Expected, $Types)

                $Expected.PSTypeNames.Add("ArmResource")

                New-ArmTemplate

                $PrivateDnsZone | Add-ArmPrivateDnsZoneVirtualNetworkLink -VirtualNetwork $VirtualNetwork

                $actual = $ArmTemplate.resources[0]

                ($actual | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                | Should -BeExactly ($Expected | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })

                $Types | ForEach-Object { $actual.PSTypeNames | Should -Contain $_ }

                @($VirtualNetwork._ResourceId, $PrivateDnsZone._ResourceId) `
                | ForEach-Object { $actual.dependsOn.Contains($_) | Should -BeTrue }
            }
        }

        Context "Integration tests" {
            It "Default" -Test {
                Invoke-IntegrationTest -ArmResourcesScriptBlock `
                {
                    
                    $ExpectedVirtualNetwork | Add-ArmResource
                    $ExpectedPrivateDnsZone | Add-ArmPrivateDnsZoneVirtualNetworkLink -VirtualNetwork $ExpectedVirtualNetwork `
                    | Add-ArmResource
                }
            }
        }
    }
}

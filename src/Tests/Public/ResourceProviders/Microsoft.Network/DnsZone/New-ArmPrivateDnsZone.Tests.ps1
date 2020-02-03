$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
    Describe "New-ArmPrivateDnsZone" {
        
        $ResourceType = "Microsoft.Network/privateDnsZones"
        $ExpectedName = "contoso.com"

        Context "Unit tests" {

            $Depth = 1
            $expectedTypes = @("PDNSZ", "ArmResource")

            It "Given the required parameters, it returns '<Expected>'" -TestCases @(
                @{ Name = $ExpectedName; Expected = [PSCustomObject][ordered]@{
                        _ResourceId = $ExpectedName | New-ArmFunctionResourceId -ResourceType $ResourceType
                        PSTypeName  = "PDNSZ"
                        type        = $ResourceType
                        name        = $ExpectedName
                        apiVersion  = "2018-09-01"
                        location    = "global"
                        properties  = @{}
                        dependsOn   = @()
                    }
                    Types = $expectedTypes
                }
            ) {
                param($Name, $Expected, $Types)

                $actual = $Name | New-ArmPrivateDnsZone

                ($actual | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                | Should -BeExactly ($Expected | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })

                $Types | ForEach-Object { $actual.PSTypeNames | Should -Contain $_ }
            }
        }

        Context "Integration tests" {
            It "Default" -Test {
                Invoke-IntegrationTest -ArmResourcesScriptBlock `
                {
                    New-ArmPrivateDnsZone -Name $ExpectedName `
                    | Add-ArmResource
                }
            }
        }
    }
}

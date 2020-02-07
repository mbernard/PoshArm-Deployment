$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
    Describe "Add-ArmApplicationInsightsActionGroupArmRoleReceiver" {

        $ResourceType = "Microsoft.Insights/actionGroups"
        $ExpectedShortName = "SomeActionGroup"
        $ExpectedName = "SomeArmRole"
        $ExpectedRoleId = "SomeGuid"

        BeforeEach {
            $ActionGroup = New-ArmResourceName $ResourceType `
            | New-ArmApplicationInsightsActionGroup -ShortName $ExpectedShortName

            $Expected = New-ArmResourceName $ResourceType `
            | New-ArmApplicationInsightsActionGroup -ShortName $ExpectedShortName
        }

        Context "Unit tests" {

            It "Given valid 'ActionGroup'(s), Role Id, Name and one or more ArmRoleReceivers it returns '<Expected>'" -TestCases @(
                @{
                    Name   = $ExpectedName
                    RoleId = $ExpectedRoleId
                },
                @{
                    Name                     = $ExpectedName
                    RoleId                   = $ExpectedRoleId
                    DisableCommonAlertSchema = $true
                },
                @{
                    Name              = $ExpectedName
                    RoleId            = $ExpectedRoleId
                    NumberOfReceivers = 3
                }
            ) {
                param($Name, $RoleId, $DisableCommonAlertSchema = $false, $NumberOfReceivers = 1)

                for ($i = 0; $i -lt $NumberOfReceivers; $i++) {
                    $Expected.properties.armRoleReceivers += @(
                        @{
                            name                 = $ExpectedName
                            roleId               = $ExpectedRoleId
                            useCommonAlertSchema = -not $DisableCommonAlertSchema
                        }
                    )
                }

                $actual = $ActionGroup

                for ($i = 0; $i -lt $NumberOfReceivers; $i++) {
                    $actual = $actual | Add-ArmApplicationInsightsActionGroupArmRoleReceiver `
                        -Name $Name `
                        -RoleId $RoleId `
                        -DisableCommonAlertSchema:$DisableCommonAlertSchema
                }

                $Depth = 3
                ($actual | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                | Should -BeExactly ($Expected | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
            }
        }

        Context "Integration tests" {
            It "Default" -Test {
                Invoke-IntegrationTest -ArmResourcesScriptBlock `
                {
                    New-ArmResourceName $ResourceType `
                    | New-ArmApplicationInsightsActionGroup -ShortName $ExpectedShortName `
                    | Add-ArmApplicationInsightsActionGroupArmRoleReceiver `
                        -Name $ExpectedName `
                        -RoleId $ExpectedRoleId `
                    | Add-ArmResource
                }
            }
            It "Multiple Arm Role Receivers" -Test {
                Invoke-IntegrationTest -ArmResourcesScriptBlock `
                {
                    New-ArmResourceName $ResourceType `
                    | New-ArmApplicationInsightsActionGroup -ShortName $ExpectedShortName `
                    | Add-ArmApplicationInsightsActionGroupArmRoleReceiver `
                        -Name $ExpectedName `
                        -RoleId $ExpectedRoleId `
                    | Add-ArmApplicationInsightsActionGroupArmRoleReceiver `
                        -Name $ExpectedName `
                        -RoleId $ExpectedRoleId `
                    | Add-ArmResource
                }
            }
        }
    }
}

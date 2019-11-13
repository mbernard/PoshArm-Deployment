$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
    Describe "Add-ArmApplicationInsightsActionGroupArmRoleReceiver" {
        
        $ResourceType = "Microsoft.Insights/actionGroups"
        BeforeEach {
            $ActionGroup = New-ArmResourceName $ResourceType `
            | New-ArmApplicationInsightsActionGroup -ShortName 'SomeActionGroup'
            $Expected = New-ArmResourceName $ResourceType `
            | New-ArmApplicationInsightsActionGroup -ShortName 'SomeActionGroup'
        }

        Context "Unit tests" {
            $ExpectedName = 'SomeArmRole'
            $ExpectedRoleId = 'SomeGuid'

            It "Given valid 'ActionGroup', Role Id, Name and one or more ArmRoleReceivers it returns '<Expected>'" -TestCases @(
                @{  
                    Name                     = $ExpectedName
                    RoleId                   = $ExpectedRoleId
                    DisableCommonAlertSchema = $false
                },
                @{  
                    Name                     = $ExpectedName
                    RoleId                   = $ExpectedRoleId
                    DisableCommonAlertSchema = $true
                },
                @{  
                    Name                     = $ExpectedName
                    RoleId                   = $ExpectedRoleId
                    DisableCommonAlertSchema = $false
                    NumberOfArmRoleReceivers = 3
                }
            ) {
                param($Name, $RoleId, $DisableCommonAlertSchema, $NumberOfArmRoleReceivers = 1)
                
                for ($i = 0; $i -lt $NumberOfArmRoleReceivers; $i++) {
                    $Expected.properties.armRoleReceivers += @(
                        @{
                            name                 = $ExpectedName
                            roleId               = $ExpectedRoleId
                            useCommonAlertSchema = $DisableCommonAlertSchema
                        }
                    )
                }

                $actual = $ActionGroup | Add-ArmApplicationInsightsActionGroupArmRoleReceiver -Name $Name -RoleId $RoleId -DisableCommonAlertSchema:$DisableCommonAlertSchema

                for ($i = 0; $i -lt ($NumberOfArmRoleReceivers - 1); $i++) {
                    $actual = $actual | Add-ArmApplicationInsightsActionGroupArmRoleReceiver -Name $Name -RoleId $RoleId -DisableCommonAlertSchema:$DisableCommonAlertSchema
                }

                ($actual | ConvertTo-Json -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                | Should -BeExactly ($Expected | ConvertTo-Json -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
            }


            $expectedException = "MismatchedPSTypeName"
            $expectedName = "someName"
            $expectedRoleId = "someRoleId"

            It "Given invalid 'ActionGroup' type, it throws '<Expected>'" -TestCases @(
                @{ ActionGroup = "ApplicationInsightsActionGroup"; Name = $expectedName; RoleId = $expectedRoleId; Expected = $expectedException }
                @{ ActionGroup = [PSCustomObject]@{Name = "Value" }; Name = $expectedName; RoleId = $expectedRoleId; ; Expected = $expectedException }
            ) { param($ActionGroup, $Name, $RoleId, $Expected)
                { Add-ArmApplicationInsightsActionGroupArmRoleReceiver -ActionGroup $ActionGroup -Name $Name -RoleId $RoleId } | Should -Throw -ErrorId $Expected
            }

            Context "Integration tests" {
                It "Default" -Test {
                    Invoke-IntegrationTest -ArmResourcesScriptBlock `
                    {
                        New-ArmResourceName $ResourceType `
                        | New-ArmApplicationInsightsActionGroup -ShortName 'SomeActionGroup' `
                        | Add-ArmApplicationInsightsActionGroupArmRoleReceiver -Name 'SomeName' -RoleId 'SomeRoleId' -DisableCommonAlertSchema:$true `
                        | Add-ArmResource
                    }
                }
            }
        }
    }
}

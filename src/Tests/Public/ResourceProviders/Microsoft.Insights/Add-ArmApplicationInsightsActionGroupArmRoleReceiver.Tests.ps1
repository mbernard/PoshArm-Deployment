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

            It "Given valid 'ActionGroup', Role Id and Name, it returns '<Expected>'" -TestCases @(
                @{  
                    Name = $ExpectedName
                    RoleId = $ExpectedRoleId
                    DisableCommonAlertSchema = $false
                },
                @{  
                    Name = $ExpectedName
                    RoleId = $ExpectedRoleId
                    DisableCommonAlertSchema = $true
                }
            ) {
                param($Name, $RoleId, $DisableCommonAlertSchema)
                
                $Expected.properties.armRoleReceivers += @(
                    @{
                        name                 = $Name
                        roleId               = $RoleId
                        useCommonAlertSchema = $DisableCommonAlertSchema
                    }
                )

                $actual = $ActionGroup | Add-ArmApplicationInsightsActionGroupArmRoleReceiver -Name $Name -RoleId $RoleId -DisableCommonAlertSchema:$DisableCommonAlertSchema

                ($actual | ConvertTo-Json -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                    | Should -BeExactly ($Expected | ConvertTo-Json -Compress| ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
            }


            $expectedException = "MismatchedPSTypeName"
            $expectedName = "someName"
            $expectedRoleId = "someRoleId"

            It "Given invalid 'ActionGroup' type, it throws '<Expected>'" -TestCases @(
                @{ ActionGroup = "ApplicationInsightsActionGroup"; Name= $expectedName; RoleId = $expectedRoleId; Expected = $expectedException }
                @{ ActionGroup = [PSCustomObject]@{Name = "Value" }; Name= $expectedName; RoleId = $expectedRoleId;; Expected = $expectedException }
            ) { param($ActionGroup, $Name, $RoleId, $Expected)
                { Add-ArmApplicationInsightsActionGroupArmRoleReceiver -ActionGroup $ActionGroup -Name $Name -RoleId $RoleId } | Should -Throw -ErrorId $Expected
            }

        # Context "Integration tests" {
        #     It "Default" -Test {
        #         Invoke-IntegrationTest -ArmResourcesScriptBlock `
        #         {
        #             New-ArmResourceName $ResourceType `
        #             | New-ArmApplicationInsightsMetricAlert `
        #             | Add-ArmApplicationInsightsMetricAlertCriteriaODataType `
        #             | Add-ArmResource
        #         }
        #     }
        }
    }
}

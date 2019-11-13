$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
    Describe "Add-ArmApplicationInsightsActionGroupEmailReceiver" {
        
        $ResourceType = "Microsoft.Insights/actionGroups"
        $expectedShortName = "SomeActionGroup"
        $ExpectedName = "Some Name"
        $ExpectedServiceUri = "service.uri.com"
        BeforeEach {
            $ActionGroup = New-ArmResourceName $ResourceType `
                | New-ArmApplicationInsightsActionGroup -ShortName $expectedShortName
            $Expected = New-ArmResourceName $ResourceType `
                | New-ArmApplicationInsightsActionGroup -ShortName $expectedShortName
        }

        Context "Unit tests" {

            It "Given valid '<ActionGroup>', '<Name>', and '<ServiceUri>', it returns '<Expected>'" -TestCases @(
                @{  
                    Name = $ExpectedName
                    ServiceUri = $ExpectedServiceUri
                    DisableCommonAlertSchema = $false
                },
                @{  
                    Name = $ExpectedName
                    Email = $ExpectedEmail
                    DisableCommonAlertSchema = $true
                }
            ) {
                param($Name, $ServiceUri, $DisableCommonAlertSchema)
                
                $Expected.properties.webHookReceivers += @(
                    @{
                        name                 = $Name
                        serviceUri           = $ServiceUri
                        useCommonAlertSchema = $DisableCommonAlertSchema
                    }
                )

                $actual = $ActionGroup | Add-ArmApplicationInsightsActionGroupWebHookReceiver `
                    -Name $Name `
                    -ServiceUri $ServiceUri `
                    -DisableCommonAlertSchema:$DisableCommonAlertSchema

                ($actual | ConvertTo-Json -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                    | Should -BeExactly ($Expected | ConvertTo-Json -Compress| ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
            }
            
            It "Given valid '<ActionGroup>', with multiple web hook receivers, it returns '<Expected>'" -TestCases @(
                @{  
                    Name = $ExpectedName
                    ServiceUri = $ExpectedServiceUri
                    NumberOfWebhookReceivers = 3
                }
            ) {
                param($Name, $ServiceUri, $NumberOfWebhookReceivers)
                
                for ($i = 0; $i -lt $NumberOfWebhookReceivers; $i++) {
                    $Expected.properties.webHookReceivers += @(
                        @{
                            name                 = $Name
                            serviceUri           = $ServiceUri
                            useCommonAlertSchema = $true
                        }
                    )
                }

                $actual = $ActionGroup | Add-ArmApplicationInsightsActionGroupWebHookReceiver `
                    -Name $Name `
                    -ServiceUri $ServiceUri `
                    -DisableCommonAlertSchema:$DisableCommonAlertSchema
                for ($i = 0; $i -lt ($NumberOfWebhookReceivers - 1); $i++) {
                    $actual = $actual | Add-ArmApplicationInsightsActionGroupWebHookReceiver `
                        -Name $Name `
                        -ServiceUri $ServiceUri `
                        -DisableCommonAlertSchema:$DisableCommonAlertSchema
                }

                ($actual | ConvertTo-Json -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                    | Should -BeExactly ($Expected | ConvertTo-Json -Compress| ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
            }

            $expectedException = "MismatchedPSTypeName"
            It "Given invalid 'ActionGroup' type, it throws '<Expected>'" -TestCases @(
                @{ ActionGroup = "ApplicationInsightsActionGroup"; Name= $expectedName; ServiceUri = $ExpectedServiceUri; Expected = $expectedException }
                @{ ActionGroup = [PSCustomObject]@{Name = "Value" }; Name= $expectedName; ServiceUri = $ExpectedServiceUri; Expected = $expectedException }
            ) { param($ActionGroup, $Name, $ServiceUri, $Expected)
                { Add-ArmApplicationInsightsActionGroupArmRoleReceiver -ActionGroup $ActionGroup -Name $Name -ServiceUri $ServiceUri } | Should -Throw -ErrorId $Expected
            }

            $expectedException = "ParameterArgumentValidationErrorNullNotAllowed"
            It "Given invalid 'Name', it throws '<Expected>'" -TestCases @(
                @{ Name= ""; ServiceUri = $ExpectedServiceUri; Expected = $expectedException }
                @{ Name= " "; ServiceUri = $ExpectedServiceUri; Expected = $expectedException }
                @{ Name= $null; ServiceUri = $ExpectedServiceUri; Expected = $expectedException }
            ) { param($Name, $ServiceUri, $Expected)
                { Add-ArmApplicationInsightsActionGroupArmRoleReceiver -ActionGroup $ActionGroup -Name $Name -ServiceUri $ServiceUri } | Should -Throw -ErrorId $Expected
            }

            $expectedException = "ParameterArgumentValidationErrorNullNotAllowed"
            It "Given invalid 'ServiceUri', it throws '<Expected>'" -TestCases @(
                @{ Name = $ExpectedName; ServiceUri = ""; Expected = $expectedException }
                @{ Name = $ExpectedName; ServiceUri = " "; Expected = $expectedException }
                @{ Name = $ExpectedName; ServiceUri = $null; Expected = $expectedException }
            ) { param($Name, $ServiceUri, $Expected)
                { Add-ArmApplicationInsightsActionGroupArmRoleReceiver -ActionGroup $ActionGroup -Name $Name -ServiceUri $ServiceUri } | Should -Throw -ErrorId $Expected
            }
        }

        # Context "Integration tests" {
        #     It "Default" -Test {
        #         Invoke-IntegrationTest -ArmResourcesScriptBlock `
        #         {
        #             $ActionGroup | Add-ArmApplicationInsightsActionGroupEmailReceiver `
        #                 -Name $ExpectedName `
        #                 -EmailAddress $ExpectedEmail `
        #             | Add-ArmResource
        #         }
        #     }
        #     It "Multiple Groups" -Test {
        #         Invoke-IntegrationTest -ArmResourcesScriptBlock `
        #         {
        #             $ActionGroup | Add-ArmApplicationInsightsActionGroupEmailReceiver `
        #                 -Name $ExpectedName `
        #                 -EmailAddress $ExpectedEmail `
        #             | Add-ArmApplicationInsightsActionGroupEmailReceiver `
        #                 -Name $ExpectedName `
        #                 -EmailAddress $ExpectedEmail `
        #             | Add-ArmResource
        #         }
        #     }
        # }
    }
}

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
                    Name       = $ExpectedName
                    ServiceUri = $ExpectedServiceUri
                }
                @{
                    Name              = $ExpectedName
                    ServiceUri        = $ExpectedServiceUri
                    NumberOfReceivers = 3
                }
            ) {
                param($Name, $ServiceUri, $NumberOfReceivers = 1)

                for ($i = 0; $i -lt $NumberOfReceivers; $i++) {
                    $Expected.properties.webHookReceivers += @(
                        @{
                            name                 = $Name
                            serviceUri           = $ServiceUri
                            useCommonAlertSchema = $true
                        }
                    )
                }

                $actual = $ActionGroup
                for ($i = 0; $i -lt $NumberOfReceivers; $i++) {
                    $actual = $actual | Add-ArmApplicationInsightsActionGroupWebHookReceiver `
                        -Name $Name `
                        -ServiceUri $ServiceUri
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
                    $ActionGroup | Add-ArmApplicationInsightsActionGroupWebHookReceiver `
                        -Name $ExpectedName `
                        -ServiceUri $ExpectedServiceUri `
                    | Add-ArmResource
                }
            }
            It "Multiple WebHook Receivers" -Test {
                Invoke-IntegrationTest -ArmResourcesScriptBlock `
                {
                    $ActionGroup | Add-ArmApplicationInsightsActionGroupWebHookReceiver `
                        -Name $ExpectedName `
                        -ServiceUri $ExpectedServiceUri `
                    | Add-ArmApplicationInsightsActionGroupWebHookReceiver `
                        -Name $ExpectedName `
                        -ServiceUri $ExpectedServiceUri `
                    | Add-ArmResource
                }
            }
        }
    }
}

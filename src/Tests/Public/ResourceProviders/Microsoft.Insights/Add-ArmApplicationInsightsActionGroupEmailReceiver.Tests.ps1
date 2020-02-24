$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
    Describe "Add-ArmApplicationInsightsActionGroupEmailReceiver" {

        $ResourceType = "Microsoft.Insights/actionGroups"
        $expectedShortName = "SomeActionGroup"
        $ExpectedName = "Some Name"
        $ExpectedEmail = "user@contoso.com"

        BeforeEach {
            $ActionGroup = New-ArmResourceName $ResourceType `
                | New-ArmApplicationInsightsActionGroup -ShortName $expectedShortName
            $Expected = New-ArmResourceName $ResourceType `
                | New-ArmApplicationInsightsActionGroup -ShortName $expectedShortName
        }

        Context "Unit tests" {
            It "Given valid '<ActionGroup>'(s), '<Name>', and '<Email>', it returns '<Expected>'" -TestCases @(
                @{
                    Name                     = $ExpectedName
                    Email                    = $ExpectedEmail
                },
                @{
                    Name                     = $ExpectedName
                    Email                    = $ExpectedEmail
                    DisableCommonAlertSchema = $true
                },
                @{
                    Name                     = $ExpectedName
                    Email                    = $ExpectedEmail
                    NumberOfReceivers        = 3
                }
            ) {
                param($Name, $Email, $DisableCommonAlertSchema = $false, $NumberOfReceivers = 1)

                for ($i = 0; $i -lt $NumberOfReceivers; $i++) {
                    $Expected.properties.emailReceivers += @(
                        @{
                            name                 = $Name
                            emailAddress         = $Email
                            useCommonAlertSchema = -not $DisableCommonAlertSchema
                        }
                    )
                }

                $actual = $ActionGroup
                for ($i = 0; $i -lt $NumberOfReceivers; $i++) {
                    $actual = $actual | Add-ArmApplicationInsightsActionGroupEmailReceiver `
                        -Name $Name `
                        -EmailAddress $Email `
                        -DisableCommonAlertSchema:$DisableCommonAlertSchema
                }

                $Depth = 3
                ($actual | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                    | Should -BeExactly ($Expected | ConvertTo-Json -Depth $Depth -Compress| ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
            }

            $expectedException = "ParameterArgumentValidationErrorEmptyStringNotAllowed"
            It "Given invalid 'Email', it throws '<Expected>'" -TestCases @(
                @{ Name = $ExpectedName; Email = ""; Expected = $expectedException }
                @{ Name = $ExpectedName; Email = " "; Expected = $expectedException }
                @{ Name = $ExpectedName; Email = $null; Expected = $expectedException }
                @{ Name = $ExpectedName; Email = "wow@wow@wow.com"; Expected = $expectedException }
                @{ Name = $ExpectedName; Email = "!wow@wow.com"; Expected = $expectedException }
            ) {
                param($Name, $RoleId, $Expected)
                {
                    Add-ArmApplicationInsightsActionGroupArmRoleReceiver -ActionGroup $ActionGroup -Name $Name -RoleId $RoleId
                } | Should -Throw -ErrorId $Expected
            }
        }

        Context "Integration tests" {
            It "Default" -Test {
                Invoke-IntegrationTest -ArmResourcesScriptBlock `
                {
                    $ActionGroup | Add-ArmApplicationInsightsActionGroupEmailReceiver `
                        -Name $ExpectedName `
                        -EmailAddress $ExpectedEmail `
                    | Add-ArmResource
                }
            }
        }
    }
}

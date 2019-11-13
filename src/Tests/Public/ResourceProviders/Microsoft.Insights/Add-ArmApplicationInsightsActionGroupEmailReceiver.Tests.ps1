$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
    Describe "Add-ArmApplicationInsightsActionGroupEmailReceiver" {
        
        $ResourceType = "Microsoft.Insights/actionGroups"
        $expectedShortName = "SomeActionGroup"
        $ExpectedName = "Some Name"
        $ExpectedEmail = "cheek@clapper.com"
        BeforeEach {
            $ActionGroup = New-ArmResourceName $ResourceType `
                | New-ArmApplicationInsightsActionGroup -ShortName $expectedShortName
            $Expected = New-ArmResourceName $ResourceType `
                | New-ArmApplicationInsightsActionGroup -ShortName $expectedShortName
        }

        Context "Unit tests" {
            It "Given valid '<ActionGroup>', '<Name>', and '<Email>', it returns '<Expected>'" -TestCases @(
                @{  
                    Name = $ExpectedName
                    Email = $ExpectedEmail
                    DisableCommonAlertSchema = $false
                },
                @{  
                    Name = $ExpectedName
                    Email = $ExpectedEmail
                    DisableCommonAlertSchema = $true
                }
            ) {
                param($Name, $Email, $DisableCommonAlertSchema)
                
                $Expected.properties.emailReceivers += @(
                    @{
                        name                 = $Name
                        emailAddress         = $Email
                        useCommonAlertSchema = $DisableCommonAlertSchema
                    }
                )

                $actual = $ActionGroup | Add-ArmApplicationInsightsActionGroupEmailReceiver `
                    -Name $Name `
                    -EmailAddress $Email `
                    -DisableCommonAlertSchema:$DisableCommonAlertSchema

                ($actual | ConvertTo-Json -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                    | Should -BeExactly ($Expected | ConvertTo-Json -Compress| ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
            }
            
            It "Given valid '<ActionGroup>', with multiple email receivers, it returns '<Expected>'" -TestCases @(
                @{  
                    Name = $ExpectedName
                    Email = $ExpectedEmail
                    NumberOfEmailReceivers = 3
                }
            ) {
                param($Name, $Email, $NumberOfEmailReceivers)
                
                for ($i = 0; $i -lt $NumberOfEmailReceivers; $i++) {
                    $Expected.properties.emailReceivers += @(
                        @{
                            name                 = $Name
                            emailAddress         = $Email
                            useCommonAlertSchema = $true
                        }
                    )
                }

                $actual = $ActionGroup | Add-ArmApplicationInsightsActionGroupEmailReceiver `
                    -Name $Name `
                    -EmailAddress $Email `
                    -DisableCommonAlertSchema:$DisableCommonAlertSchema
                for ($i = 0; $i -lt ($NumberOfEmailReceivers - 1); $i++) {
                    $actual = $actual | Add-ArmApplicationInsightsActionGroupEmailReceiver `
                        -Name $Name `
                        -EmailAddress $Email `
                        -DisableCommonAlertSchema:$DisableCommonAlertSchema
                }

                ($actual | ConvertTo-Json -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                    | Should -BeExactly ($Expected | ConvertTo-Json -Compress| ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
            }

            $expectedException = "MismatchedPSTypeName"
            It "Given invalid 'ActionGroup' type, it throws '<Expected>'" -TestCases @(
                @{ ActionGroup = "ApplicationInsightsActionGroup"; Name= $expectedName; Email = $ExpectedEmail; Expected = $expectedException }
                @{ ActionGroup = [PSCustomObject]@{Name = "Value" }; Name= $expectedName; Email = $ExpectedEmail; Expected = $expectedException }
            ) { param($ActionGroup, $Name, $RoleId, $Expected)
                { Add-ArmApplicationInsightsActionGroupArmRoleReceiver -ActionGroup $ActionGroup -Name $Name -RoleId $RoleId } | Should -Throw -ErrorId $Expected
            }

            $expectedException = "ParameterArgumentValidationErrorEmptyStringNotAllowed"
            It "Given invalid 'Name', it throws '<Expected>'" -TestCases @(
                @{ Name= ""; Email = $ExpectedEmail; Expected = $expectedException }
                @{ Name= " "; Email = $ExpectedEmail; Expected = $expectedException }
                @{ Name= $null; Email = $ExpectedEmail; Expected = $expectedException }
            ) { param($Name, $RoleId, $Expected)
                { Add-ArmApplicationInsightsActionGroupArmRoleReceiver -ActionGroup $ActionGroup -Name $Name -RoleId $RoleId } | Should -Throw -ErrorId $Expected
            }

            $expectedException = "ParameterArgumentValidationErrorEmptyStringNotAllowed"
            It "Given invalid 'Email', it throws '<Expected>'" -TestCases @(
                @{ Name = $ExpectedName; Email = ""; Expected = $expectedException }
                @{ Name = $ExpectedName; Email = " "; Expected = $expectedException }
                @{ Name = $ExpectedName; Email = $null; Expected = $expectedException }
                @{ Name = $ExpectedName; Email = "wow@wow@wow.com"; Expected = $expectedException }
                @{ Name = $ExpectedName; Email = "!wow@wow.com"; Expected = $expectedException }
            ) { param($Name, $RoleId, $Expected)
                { Add-ArmApplicationInsightsActionGroupArmRoleReceiver -ActionGroup $ActionGroup -Name $Name -RoleId $RoleId } | Should -Throw -ErrorId $Expected
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
            It "Multiple Groups" -Test {
                Invoke-IntegrationTest -ArmResourcesScriptBlock `
                {
                    $ActionGroup | Add-ArmApplicationInsightsActionGroupEmailReceiver `
                        -Name $ExpectedName `
                        -EmailAddress $ExpectedEmail `
                    | Add-ArmApplicationInsightsActionGroupEmailReceiver `
                        -Name $ExpectedName `
                        -EmailAddress $ExpectedEmail `
                    | Add-ArmResource
                }
            }
        }
    }
}

$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
    Describe "New-ArmApplicationInsightsActionGroup" {
        $ResourceType = "Microsoft.Insights/actionGroups"
        $expectedName = "name1"
        $expectedShortName = "n1"

        Context "Unit tests" {
            $expectedTypes = @("ApplicationInsightsActionGroup", "ArmResource")
            It "Given valid 'Name' and 'ShortName' parameters, it returns '<Expected>'" -TestCases @(
                @{
                    Name = $expectedName;
                    ShortName = $expectedShortName;
                    Types = $expectedTypes;
                    Expected = [PSCustomObject][ordered]@{
                        _ResourceId = $expectedName | New-ArmFunctionResourceId -ResourceType $ResourceType
                        type        = $ResourceType
                        name        = $expectedName
                        apiVersion  = "2019-06-01"
                        location    = "global"
                        properties  = @{
                            groupShortName      = $expectedShortName
                            enabled             = $true
                            emailReceivers      = @()
                            webHookReceivers    = @()
                            armRoleReceivers    = @()
                        }
                        resources   = @()
                        dependsOn   = @()
                    }
                }
            ) {
                param($Name, $ShortName, $Types, $Expected)

                $actual = $Name | New-ArmApplicationInsightsActionGroup -ShortName $ShortName

                $Depth = 3
                ($actual | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                    | Should -BeExactly ($Expected | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })

                $Types | ForEach-Object { $actual.PSTypeNames | Should -Contain $_ }
            }

            $expectedApiVersion = "2020-01-01"
            It "Given a valid set of parameters, it returns '<Expected>'" -TestCases @(
                @{  Name = $expectedName;
                    ShortName = $expectedShortName;
                    ApiVersion = $expectedApiVersion
                    Types = $expectedTypes;
                    Expected = [PSCustomObject][ordered]@{
                        _ResourceId = $expectedName | New-ArmFunctionResourceId -ResourceType $ResourceType
                        type        = $ResourceType
                        name        = $expectedName
                        apiVersion  = $expectedApiVersion
                        location    = "global"
                        properties  = @{
                            groupShortName      = $expectedShortName
                            enabled             = $false
                            emailReceivers      = @()
                            webHookReceivers    = @()
                            armRoleReceivers    = @()
                        }
                        resources   = @()
                        dependsOn   = @()
                    }
                }
            ) {
                param($Name, $ShortName, $ApiVersion, $Disabled, $Types, $Expected)

                $actual = $Name | New-ArmApplicationInsightsActionGroup `
                    -ShortName $ShortName `
                    -ApiVersion $ApiVersion `
                    -Disabled

                $Depth = 3
                ($actual | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                    | Should -BeExactly ($Expected | ConvertTo-Json -Depth $Depth -Compress| ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })

                $Types | ForEach-Object { $actual.PSTypeNames | Should -Contain $_ }
            }

            $ParameterArgumentValidationError = "ParameterArgumentValidationError"
            It "Given invalid '<Name>' parameter and valid '<ShortName>' parameter, it throws '<Expected>'" -TestCases @(
            	@{ Name = ""; ShortName = $expectedShortName; Expected = $ParameterArgumentValidationError },
            	@{ Name = " "; ShortName = $expectedShortName; Expected = $ParameterArgumentValidationError },
            	@{ Name = $null; ShortName = $expectedShortName; Expected = $ParameterArgumentValidationError }
            ) { param($Name, $ShortName, $Expected)
            	{ New-ArmApplicationInsightsActionGroup -Name $Name -ShortName $ShortName } | Should -Throw -ErrorId $Expected
            }

            It "Given valid '<Name>' parameter and invalid '<ShortName>' parameter, it throws '<Expected>'" -TestCases @(
            	@{ Name = $expectedName; ShortName = ""; Expected = $ParameterArgumentValidationError },
            	@{ Name = $expectedName; ShortName = " "; Expected = $ParameterArgumentValidationError },
            	@{ Name = $expectedName; ShortName = $null; Expected = $ParameterArgumentValidationError }
            ) { param($Name, $ShortName, $Expected)
            	{ New-ArmApplicationInsightsActionGroup -Name $Name -ShortName $ShortName } | Should -Throw -ErrorId $Expected
            }
        }

        Context "Integration tests" {
            It "Default" -Test {
                Invoke-IntegrationTest -ArmResourcesScriptBlock `
                {
                    New-ArmResourceName $ResourceType `
                    | New-ArmApplicationInsightsActionGroup -ShortName $expectedShortName `
                    | Add-ArmResource
                }
            }
        }
    }
}

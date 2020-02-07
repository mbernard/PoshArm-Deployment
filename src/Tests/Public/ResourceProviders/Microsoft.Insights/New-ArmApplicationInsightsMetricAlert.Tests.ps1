$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
    Describe "New-ArmApplicationInsightsMetricAlert" {
        $ResourceType = "Microsoft.Insights/metricAlerts"
        Context "Unit tests" {
            $expectedName = "name1"
            $expectedTypes = @("ApplicationInsightsMetricAlert", "ArmResource")

            It "Given a valid '<Name>' parameter, it returns '<Expected>'" -TestCases @(
                @{ Name = $expectedName; Types = $expectedTypes; Expected = [PSCustomObject][ordered]@{
                        _ResourceId = $expectedName | New-ArmFunctionResourceId -ResourceType $ResourceType
                        type        = $ResourceType
                        name        = $expectedName
                        apiVersion  = "2018-03-01"
                        location    = "global"
                        properties  = @{
                            description         = ""
                            severity            = 3
                            enabled             = $true
                            scopes              = @()
                            evaluationFrequency = "PT1M"
                            windowSize          = "PT5M"
                            criteria            = @{
                                "odata.type" = "Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria"
                                allOf               = @()
                            }
                            actions             = @()
                        }
                        dependsOn   = @()
                    }
                }
            ) {
                param($Name, $Types, $Expected)

                $actual = $Name | New-ArmApplicationInsightsMetricAlert

                $Depth = 3
                ($actual | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                    | Should -BeExactly ($Expected | ConvertTo-Json -Depth 10 -Compress| ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })

                $Types | ForEach-Object { $actual.PSTypeNames | Should -Contain $_ }
            }

            $expectedApiVersion = "2020-01-01"
            $expectedDescription = "Very cool/modern"
            $expectedWindowSizeInMinutes = 5
            $expectedSeverity = 0
            $expectedEvaluationFrequencyInMinutes = 60
            $expectedScopes = @("scope1", "scope2")
            It "Given a valid set of parameters, it returns '<Expected>'" -TestCases @(
                @{  Name = $expectedName;
                    ApiVersion = $expectedApiVersion;
                    Description = $expectedDescription;
                    WindowSizeInMinutes = $expectedWindowSizeInMinutes;
                    Severity = $expectedSeverity;
                    EvaluationFrequencyInMinutes = $expectedEvaluationFrequencyInMinutes;
                    Scopes = $expectedScopes;
                    Types = $expectedTypes;
                    Expected = [PSCustomObject][ordered]@{
                        _ResourceId = $expectedName | New-ArmFunctionResourceId -ResourceType $ResourceType
                        type        = $ResourceType
                        name        = $expectedName
                        apiVersion  = $expectedApiVersion
                        location    = "global"
                        properties  = @{
                            description         = $expectedDescription
                            severity            = $expectedSeverity
                            enabled             = $false
                            scopes              = $expectedScopes
                            evaluationFrequency = "PT$expectedEvaluationFrequencyInMinutes" + "M"
                            windowSize          = "PT$expectedWindowSizeInMinutes" + "M"
                            criteria            = @{
                                "odata.type" = "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                                allOf               = @()
                            }
                            actions             = @()
                        }
                        dependsOn   = @()
                    }
                }
            ) {
                param($Name,
                    $ApiVersion,
                    $Description,
                    $WindowSizeInMinutes,
                    $Severity,
                    $EvaluationFrequencyInMinutes,
                    $Scopes,
                    $Disabled,
                    $Types,
                    $Expected)

                $actual = $Name | New-ArmApplicationInsightsMetricAlert `
                    -ApiVersion $ApiVersion `
                    -Description $Description `
                    -WindowSizeInMinutes $WindowSizeInMinutes `
                    -Severity $Severity `
                    -EvaluationFrequencyInMinutes $EvaluationFrequencyInMinutes `
                    -Scopes $Scopes `
                    -MultipleResource `
                    -Disabled

                $Depth = 3
                ($actual | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                    | Should -BeExactly ($Expected | ConvertTo-Json -Depth $Depth -Compress| ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })

                $Types | ForEach-Object { $actual.PSTypeNames | Should -Contain $_ }
            }

            $ParameterArgumentValidationError = "ParameterArgumentValidationError"
            It "Given an invalid 'Name' parameter, it throws '<Expected>'" -TestCases @(
            	@{ Name = "a bad name"; Expected = $ParameterArgumentValidationError },
            	@{ Name = ""; Expected = $ParameterArgumentValidationError },
            	@{ Name = " "; Expected = $ParameterArgumentValidationError },
            	@{ Name = $null; Expected = $ParameterArgumentValidationError }
            ) { param($Name, $Expected)
            	{ New-ArmApplicationInsightsMetricAlert -Name $Name } | Should -Throw -ErrorId $Expected
            }
        }

        Context "Integration tests" {
            It "Default" -Test {
                Invoke-IntegrationTest -ArmResourcesScriptBlock `
                {
                    New-ArmResourceName $ResourceType `
                    | New-ArmApplicationInsightsMetricAlert `
                    | Add-ArmResource
                }
            }
        }
    }
}
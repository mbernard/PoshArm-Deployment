$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
    Describe "New-ArmApplicationInsightsMetricAlert" {
        $ResourceType = "Microsoft.Insights/metricAlerts"
        Context "Unit tests" {
            $expectedName = "name1"
            $expectedTypes = @("ApplicationInsightsMetricAlert", "ArmResource")
            It "Given a valid 'Name' parameter, it returns '<Expected>'" -TestCases @(
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

                ($actual | ConvertTo-Json -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                    | Should -BeExactly ($Expected | ConvertTo-Json -Compress| ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })

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
                                allOf               = @()
                            }
                            actions             = @()
                        }
                        dependsOn   = @()
                    }
                }
            ) {
                param($Name, $ApiVersion, $Description, $WindowSizeInMinutes, $Severity, $EvaluationFrequencyInMinutes, $Scopes, $Disabled, $Types, $Expected)

                $actual = $Name | New-ArmApplicationInsightsMetricAlert `
                    -ApiVersion $ApiVersion `
                    -Description $Description `
                    -WindowSizeInMinutes $WindowSizeInMinutes `
                    -Severity $Severity `
                    -EvaluationFrequencyInMinutes $EvaluationFrequencyInMinutes `
                    -Scopes $Scopes `
                    -Disabled 
                ($actual | ConvertTo-Json -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                    | Should -BeExactly ($Expected | ConvertTo-Json -Compress| ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })

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
            It "Given an invalid 'WindowSizeInMinutes' parameter, it throws '<Expected>'" -TestCases @(
            	@{ Name = $expectedName; WindowSizeInMinutes = -1; Expected = $ParameterArgumentValidationError },
            	@{ Name = $expectedName; WindowSizeInMinutes = 0; Expected = $ParameterArgumentValidationError },
            	@{ Name = $expectedName; WindowSizeInMinutes = 2000; Expected = $ParameterArgumentValidationError }
            ) { param($Name, $WindowSizeInMinutes, $Expected)
                { New-ArmApplicationInsightsMetricAlert -Name $Name -WindowSizeInMinutes $WindowSizeInMinutes } `
                 | Should -Throw -ErrorId $Expected
            }
            It "Given an invalid 'Severity' parameter, it throws '<Expected>'" -TestCases @(
            	@{ Name = $expectedName; Severity = -2; Expected = $ParameterArgumentValidationError },
            	@{ Name = $expectedName; Severity = 5; Expected = $ParameterArgumentValidationError }
            ) { param($Name, $Severity, $Expected)
                { New-ArmApplicationInsightsMetricAlert -Name $Name -Severity $Severity } `
                 | Should -Throw -ErrorId $Expected
            }
            It "Given an invalid 'EvaluationFrequencyInMinutes' parameter, it throws '<Expected>'" -TestCases @(
            	@{ Name = $expectedName; EvaluationFrequencyInMinutes = -10; Expected = $ParameterArgumentValidationError },
            	@{ Name = $expectedName; EvaluationFrequencyInMinutes = 0; Expected = $ParameterArgumentValidationError }
            	@{ Name = $expectedName; EvaluationFrequencyInMinutes = 2000; Expected = $ParameterArgumentValidationError }
            ) { param($Name, $EvaluationFrequencyInMinutes, $Expected)
                { New-ArmApplicationInsightsMetricAlert -Name $Name -EvaluationFrequencyInMinutes $EvaluationFrequencyInMinutes } `
                 | Should -Throw -ErrorId $Expected
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
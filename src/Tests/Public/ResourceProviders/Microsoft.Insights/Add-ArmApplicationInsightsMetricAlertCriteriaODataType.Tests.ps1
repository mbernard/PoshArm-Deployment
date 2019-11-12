$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
    Describe "New-ArmApplicationInsightsActionGroup" {
        
        $ResourceType = "Microsoft.Insights/metricAlerts"
        BeforeEach {
            $MetricAlert = New-ArmResourceName $ResourceType `
                | New-ArmApplicationInsightsMetricAlert
            $Expected = New-ArmResourceName $ResourceType `
                | New-ArmApplicationInsightsMetricAlert
        }

        Context "Unit tests" {
            $expectedTypes = @("ApplicationInsightsMetricAlert", "ArmResource")     

            It "Given valid 'MetricAlert', it returns '<Expected>'" -TestCases @(
                @{  
                    Types = $expectedTypes
                }
            ) {
                param($Types)

                $Expected.properties.criteria["odata.type"] = "Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria"

                $actual = $MetricAlert | Add-ArmApplicationInsightsMetricAlertCriteriaODataType

                ($actual | ConvertTo-Json -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                    | Should -BeExactly ($Expected | ConvertTo-Json -Compress| ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })

                $Types | ForEach-Object { $actual.PSTypeNames | Should -Contain $_ }
            }
            
            $expectedODataType = "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
            It "Given valid 'MetricAlert' and 'ODataType', it returns '<Expected>'" -TestCases @(
                @{  
                    ODataType = $expectedODataType
                    Types = $expectedTypes
                }
            ) {
                param($ODataType, $Types)

                $Expected.properties.criteria["odata.type"] = $expectedODataType

                $actual = $MetricAlert | Add-ArmApplicationInsightsMetricAlertCriteriaODataType -ODataType $ODataType

                ($actual | ConvertTo-Json -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                    | Should -BeExactly ($Expected | ConvertTo-Json -Compress| ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })

                $Types | ForEach-Object { $actual.PSTypeNames | Should -Contain $_ }
            }

            It "Given valid 'Name' parameter and invalid 'ShortName' parameter, it throws '<Expected>'" -TestCases @(
            	@{ Name = $expectedName; ShortName = ""; Expected = $ParameterArgumentValidationError },
            	@{ Name = $expectedName; ShortName = " "; Expected = $ParameterArgumentValidationError },
            	@{ Name = $expectedName; ShortName = $null; Expected = $ParameterArgumentValidationError }
            ) { param($Name, $ShortName, $Expected)
            	{ New-ArmApplicationInsightsActionGroup -Name $Name -ShortName $ShortName } | Should -Throw -ErrorId $Expected
            }


            $expectedException = "MismatchedPSTypeName"
            It "Given invalid 'MetricAlert' type, it throws '<Expected>'" -TestCases @(
                @{ MetricAlert = "ApplicationInsightsMetricAlert"; Expected = $expectedException }
                @{ MetricAlert = [PSCustomObject]@{Name = "Value" }; Expected = $expectedException }
            ) { param($MetricAlert, $Expected)
                { Add-ArmApplicationInsightsMetricAlertCriteriaODataType -MetricAlert $MetricAlert } | Should -Throw -ErrorId $Expected
            }

            $expectedException = "ParameterArgumentValidationErrorNullNotAllowed"
            It "Given null 'MetricAlert', it throws '<Expected>'" -TestCases @(
                @{ MetricAlert = $null; Expected = $expectedException }
            ) { param($MetricAlert, $Expected)
                { Add-ArmApplicationInsightsMetricAlertCriteriaODataType -MetricAlert $MetricAlert } | Should -Throw -ErrorId $Expected
            }

            $expectedException = "ParameterArgumentValidationErrorNullNotAllowed"
            It "Given a valid 'MetricAlert' and invalid, it throws '<Expected>'" -TestCases @(
                @{ ODataType = "(*&(_&^%$)("; Expected = $expectedException },
                @{ ODataType = $null; Expected = $expectedException },
                @{ ODataType = ""; Expected = $expectedException }
                @{ ODataType = " "; Expected = $expectedException }
            ) { param($MetricAlert, $ODataType, $Expected)
                { Add-ArmApplicationInsightsMetricAlertCriteriaODataType -MetricAlert $MetricAlert -ODataType $ODataType } | Should -Throw -ErrorId $Expected
            }

        }

        Context "Integration tests" {
            It "Default" -Test {
                Invoke-IntegrationTest -ArmResourcesScriptBlock `
                {
                    New-ArmResourceName $ResourceType `
                    | New-ArmApplicationInsightsMetricAlert `
                    | Add-ArmApplicationInsightsMetricAlertCriteriaODataType `
                    | Add-ArmResource
                }
            }
        }
    }
}

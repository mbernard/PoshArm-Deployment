$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
    Describe "Add-ArmApplicationInsightsMetricAlertStaticCriteria" {

        $ResourceType = "Microsoft.Insights/metricAlerts"
        $ExpectedMetricAlertName = "someMetricAlert"

        BeforeEach {
            $MetricAlert = New-ArmApplicationInsightsMetricAlert -Name $ExpectedMetricAlertName
            $Expected = New-ArmApplicationInsightsMetricAlert -Name $ExpectedMetricAlertName
        }

        $ExpectedName = 'SomeName'
        $ExpectedMetricName = 'SomeMetricName'
        $ExpectedMetricNamespace = 'SomeNamespace'
        $ExpectedDimensions = @(@{
                name     = "StatusCode"
                values   = @(429)
                operator = "Include"
            })
        $ExpectedOperator = "Equals"
        $ExpectedThreshold = 10
        $ExpectedTimeAggregation = 'Maximum'

        Context "Unit tests" {
            It "Given valid mandatory params it returns '<Expected>'" -TestCases @(
                @{
                    Name            = $ExpectedName
                    MetricName      = $ExpectedMetricName
                    MetricNamespace = $ExpectedMetricNamespace
                    Dimensions      = $ExpectedDimensions
                    Operator        = $ExpectedOperator
                    Threshold       = $ExpectedThreshold
                    TimeAggregation = $ExpectedTimeAggregation
                }
                @{
                    Name             = $ExpectedName
                    MetricName       = $ExpectedMetricName
                    MetricNamespace  = $ExpectedMetricNamespace
                    Dimensions       = $ExpectedDimensions
                    Operator         = $ExpectedOperator
                    Threshold        = $ExpectedThreshold
                    TimeAggregation  = $ExpectedTimeAggregation
                    NumberOfCriteria = 3
                }
            ) {
                param(
                    $Name,
                    $MetricName,
                    $MetricNamespace,
                    $Dimensions,
                    $Operator,
                    $Threshold,
                    $TimeAggregation,
                    $NumberOfCriteria = 1)

                for ($i = 0; $i -lt $NumberOfCriteria; $i++) {
                    $Expected.properties.criteria.allOf += @(
                        @{
                            criterionType   = "StaticThresholdCriterion"
                            name            = $Name
                            metricName      = $MetricName
                            metricNamespace = $MetricNamespace
                            dimensions      = $Dimensions
                            operator        = $Operator
                            threshold       = $Threshold
                            timeAggregation = $TimeAggregation
                        }
                    )
                }

                $actual = $MetricAlert
                for ($i = 0; $i -lt $NumberOfCriteria; $i++) {
                    $actual = $actual | Add-ArmApplicationInsightsMetricAlertStaticCriteria -Name $Name `
                        -MetricName $MetricName `
                        -MetricNamespace $MetricNamespace `
                        -Dimensions $Dimensions `
                        -Operator $Operator `
                        -Threshold $Threshold `
                        -TimeAggregation $TimeAggregation
                }

                $Depth = 7
                ($actual | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                | Should -BeExactly ($Expected | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
            }
        }

        Context "Integration tests" {
            It "Default" -Test {
                Invoke-IntegrationTest -ArmResourcesScriptBlock `
                {
                    New-ArmResourceName $ResourceType `
                    | New-ArmApplicationInsightsMetricAlert `
                    | Add-ArmApplicationInsightsMetricAlertStaticCriteria -Name $ExpectedName `
                        -MetricName $ExpectedMetricName `
                        -MetricNamespace $ExpectedMetricNamespace `
                        -Dimensions $ExpectedDimensions `
                        -Operator $ExpectedOperator `
                        -Threshold $ExpectedThreshold `
                        -TimeAggregation $ExpectedTimeAggregation `
                    | Add-ArmResource
                }
            }
        }
        It "Multiple metric alert criteria" -Test {
            Invoke-IntegrationTest -ArmResourcesScriptBlock `
            {
                New-ArmResourceName $ResourceType `
                | New-ArmApplicationInsightsMetricAlert `
                | Add-ArmApplicationInsightsMetricAlertStaticCriteria -Name $ExpectedName `
                    -MetricName $ExpectedMetricName `
                    -MetricNamespace $ExpectedMetricNamespace `
                    -Dimensions $ExpectedDimensions `
                    -Operator $ExpectedOperator `
                    -Threshold $ExpectedThreshold `
                    -TimeAggregation $ExpectedTimeAggregation `
                | Add-ArmApplicationInsightsMetricAlertStaticCriteria -Name $ExpectedName `
                    -MetricName $ExpectedMetricName `
                    -MetricNamespace $ExpectedMetricNamespace `
                    -Dimensions $ExpectedDimensions `
                    -Operator $ExpectedOperator `
                    -Threshold $ExpectedThreshold `
                    -TimeAggregation $ExpectedTimeAggregation `
                | Add-ArmResource
            }
        }
    }
}

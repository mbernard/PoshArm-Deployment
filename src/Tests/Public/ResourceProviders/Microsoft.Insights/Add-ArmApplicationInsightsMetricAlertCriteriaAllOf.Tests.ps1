$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
  Describe "Add-ArmApplicationInsightsMetricAlertCriteriaAllOf" {
        
    $ResourceType = "Microsoft.Insights/metricAlerts"
    BeforeEach {
      $MetricAlert = New-ArmApplicationInsightsMetricAlert -Name 'someMetricAlert'
      $Expected = New-ArmApplicationInsightsMetricAlert -Name 'someMetricAlert'
    }

    $ExpectedName = 'SomeName'
    $ExpectedMetricName = 'SomeMetricName'
    $ExpectedMetricNamespace = 'SomeNamespace'
    $ExpectedDimensions = @('FirstDimension', 'SecondDimension')
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
      ) {
        param(
          $Name,
          $MetricName ,
          $MetricNamespace ,
          $Dimensions ,
          $Operator ,
          $Threshold ,
          $TimeAggregation)
                
        $Expected.properties.criteria.allOf += @(
          @{
            name            = $Name
            metricName      = $MetricName
            metricNamespace = $MetricNamespace
            dimensions      = $Dimensions
            operator        = $Operator
            threshold       = $Threshold
            timeAggregation = $TimeAggregation
          }
        )

        $actual = $MetricAlert | Add-ArmApplicationInsightsMetricAlertCriteriaAllOf -Name $Name `
          -MetricName $MetricName `
          -MetricNamespace $MetricNamespace `
          -Dimensions $Dimensions `
          -Operator $Operator `
          -Threshold $Threshold `
          -TimeAggregation $TimeAggregation 

        ($actual | ConvertTo-Json -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
        | Should -BeExactly ($Expected | ConvertTo-Json -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
      }


      $ExpectedException = "MismatchedPSTypeName"

      It "Given an invalid Metric Alert, it throws '<Expected>'" -TestCases @(
        @{ MetricAlert = "ApplicationInsightsMetricAlert"
          Expected     = $ExpectedException
        }
        @{ MetricAlert = [PSCustomObject]@{Name = "Value" }
          Expected     = $ExpectedException
        }
      ) { param($MetricAlert, $Expected)
        { Add-ArmApplicationInsightsMetricAlertCriteriaAllOf -MetricAlert $MetricAlert `
            -Name $Name `
            -MetricName $ExpectedMetricName `
            -MetricNamespace $ExpectedMetricNamespace `
            -Dimensions $ExpectedDimensions `
            -Operator $ExpectedOperator `
            -Threshold $ExpectedThreshold `
            -TimeAggregation $ExpectedTimeAggregation } | Should -Throw -ErrorId $Expected
      }

      Context "Integration tests" {
        It "Default" -Test {
          Invoke-IntegrationTest -ArmResourcesScriptBlock `
          {
            New-ArmResourceName $ResourceType `
            | New-ArmApplicationInsightsMetricAlert `
            | Add-ArmApplicationInsightsMetricAlertCriteriaAllOf -Name $ExpectedName `
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
  }
}

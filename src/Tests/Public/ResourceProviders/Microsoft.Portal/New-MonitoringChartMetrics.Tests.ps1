$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
  Describe "New-MonitoringChartMetrics" {
    $Depth = 2
    $ExpectedName = 'performanceCounters/processorCpuPercentage' 
    $ExpectedAggregationType = 4
    $ExpectedNamespace = 'microsoft.insights/components'
    $ExpectedDisplayName = 'Processor time'
    $ExpectedColor = '#47BDF5'
    $ExpectedResourceDisplayName = 'SomeResourceName'

    $ApplicationInsights = New-ArmResourceName "microsoft.insights/components" `
    | New-ArmApplicationInsightsResource -Location "SomeLocation"

    Context "Unit tests" {
      It "Given an '<Id>', '<Name>', '<DisplayName>', '<Namespace>', '<AggregationType>', '<ResourceDisplayName>',
       '<Color>' it returns '<Expected>' " -TestCases @(
        @{ 
          Color               = $ExpectedColor
          ResourceDisplayName = $ExpectedResourceDisplayName
          Namespace           = $ExpectedNamespace
          Name                = $ExpectedName
          Id                  = $ApplicationInsights._ResourceId
          DisplayName         = $ExpectedDisplayName
          AggregationType     = $ExpectedAggregationType 
          Expected            = [PSCustomObject]@{
            PSTypeName          = "DashboardMetric"
            resourceMetadata    = @{ id = $ApplicationInsights._ResourceId }
            name                = $ExpectedName;
            aggregationType     = $ExpectedAggregationType;
            namespace           = $ExpectedNamespace;
            metricVisualization = [PSCustomObject]@{              
              displayName         = $ExpectedDisplayName        
              resourceDisplayName = $ExpectedResourceDisplayName   
              color               = $ExpectedColor 
            }
          }
        }
      ) {
        param($Color, $ResourceDisplayName, $Namespace, $Name, $Id, $DisplayName, $AggregationType, $Expected)

        $actual = New-MonitoringChartMetrics -Color $Color -Namespace $Namespace -Name $Name -Id $Id -DisplayName $DisplayName -AggregationType $AggregationType -ResourceDisplayName $ResourceDisplayName
        ($actual | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
        | Should -Be ($Expected | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
      }
      It "Given an '<Id>', '<Name>', '<DisplayName>', '<Namespace>', '<AggregationType>' it returns '<Expected>' without resourceDisplayName or color" -TestCases @(
        @{ 
          Namespace       = $ExpectedNamespace
          Name            = $ExpectedName
          Id              = $ApplicationInsights._ResourceId
          DisplayName     = $ExpectedDisplayName
          AggregationType = $ExpectedAggregationType 
          Expected        = [PSCustomObject][ordered]@{
            PSTypeName          = "DashboardMetric"
            resourceMetadata    = @{ id = $ApplicationInsights._ResourceId }
            name                = $ExpectedName;
            aggregationType     = $ExpectedAggregationType;
            namespace           = $ExpectedNamespace;
            metricVisualization = @{ 
              displayName = $ExpectedDisplayName
            }
          }
        }
      ) {
        param($Namespace, $Name, $Id, $DisplayName, $AggregationType, $Expected)

        $actual = New-MonitoringChartMetrics -Namespace $Namespace -Name $Name -Id $Id -DisplayName $DisplayName -AggregationType $AggregationType
        ($actual | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
        | Should -Be ($Expected | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
      }        
    }
  }
}
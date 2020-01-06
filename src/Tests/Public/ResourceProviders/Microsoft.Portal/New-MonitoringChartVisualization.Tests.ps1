$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
  Describe "New-AnalyticsChartDimension" {
    $Depth = 2
    $ExpectedChartType = 2
    $ExpectedLegendVisible = $false
    $ExpectedLegendPosition = 2
    $ExpectedHideLegendSubtitle = $true
    $ExpectedXIsVisible = $false
    $ExpectedXAxisType = 2
    $ExpectedYIsVisible = $false
    $ExpectedYAxisType = 1

    Context "Unit tests" {
      It "Given an '<xName>', '<xType>', '<yName>', '<yType>' and '<aggregation>' it returns '<Expected>' " -TestCases @(
        @{ 
          ChartType          = $ExpectedChartType
          LegendVisible      = $ExpectedLegendVisible
          LegendPosition     = $ExpectedLegendPosition
          HideLegendSubtitle = $ExpectedHideLegendSubtitle
          XIsVisible         = $ExpectedXIsVisible
          XAxisType          = $ExpectedXAxisType
          YIsVisible         = $ExpectedYIsVisible
          YAxisType          = $ExpectedYAxisType
          Expected           = [PSCustomObject]@{ 
            PSTypeName          = "ChartVisualization"
            chartType           = $ExpectedChartType
            legendVisualization = @{ 
              isVisible    = $ExpectedLegendVisible
              position     = $ExpectedLegendPosition
              hideSubtitle = $ExpectedHideLegendSubtitle 
            }
            axisVisualization   = @{ 
              x = @{ 
                isVisible = $ExpectedXIsVisible
                axisType  = $ExpectedXAxisType 
              }
              y = @{ 
                isVisible = $ExpectedYIsVisible
                axisType  = $ExpectedYAxisType
              } 
            } 
          }
        }
      ) {
        param($ChartType, $LegendVisible, $LegendPosition, $HideLegendSubtitle, $XIsVisible, $XAxisType, $YIsVisible, $YAxisType, $Expected)

        $actual = New-MonitoringChartVisualization -ChartType $ChartType -LegendVisible $LegendVisible -LegendPosition $LegendPosition `
          -HideLegendSubtitle $HideLegendSubtitle -XIsVisible $XIsVisible -XAxisType $XAxisType -YIsVisible $YIsVisible -YAxisType $YAxisType
        ($actual | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
        | Should -Be ($Expected | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
      }
    }      
  }
}
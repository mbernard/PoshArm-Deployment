$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
  Describe "New-AnalyticsChartDimension" {
    $Depth = 2
    $ExpectedXName = 'TimeGenerated' 
    $ExpectedXType = 'datetime'
    $ExpectedYName = 'sum_Count'
    $ExpectedYType = 'long'
    $ExpectedAggregation = 'Sum'

    Context "Unit tests" {
      It "Given an '<xName>', '<xType>', '<yName>', '<yType>' and '<aggregation>' it returns '<Expected>' " -TestCases @(
        @{ 
          XName       = $ExpectedXName
          XType       = $ExpectedXType
          YName       = $ExpectedYName
          YType       = $ExpectedYType
          Aggregation = $ExpectedAggregation
          Expected    = [PSCustomObject]@{ 
            PSTypeName  = "ChartDimension"
            xAxis       = @{ 
              name = $ExpectedXName
              type = $ExpectedXType
            }
            yAxis       = @(
              @{
                name = $ExpectedYName
                type = $ExpectedYType
              })
            splitBy     = @(); 
            aggregation = $ExpectedAggregation
          }
        }
      ) {
        param($XName, $XType, $YName, $YType, $Aggregation, $Expected)

        $actual = New-AnalyticsChartDimension -xName $XName -xType $XType -yName $YName -yType $YType -aggregation $Aggregation
        ($actual | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
        | Should -Be ($Expected | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
      }
    }      
  }
}
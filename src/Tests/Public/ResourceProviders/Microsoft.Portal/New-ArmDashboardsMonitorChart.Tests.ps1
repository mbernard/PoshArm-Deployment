$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
  Describe "New-ArmDashboardsMonitorChart" {
    $Depth = 99
    $ExpectedMetrics = @(
      [PSCustomObject]@{
        PSTypeName = "ChartMetric"
        value      = "FirstMetric" 
      }, 
      [PSCustomObject]@{ 
        PSTypeName = "ChartMetric"
        value      = "SecondMetric" 
      })
    $ExpectedVisualization = [PSCustomObject]@{ 
      PSTypeName          = "ChartVisualization"
      charType            = 2
      legendVisualization = @{ isVisible = $true }
    }
    $ExpectedTitle = "SomeTitle"

    Context "Unit tests" {
      It "Given valid parameters it returns '<Expected>'" -TestCases @(
        @{  
          Metrics       = $ExpectedMetrics
          Visualization = $ExpectedVisualization
          Title         = $ExpectedTitle
          Expected      = [PSCustomObject][ordered]@{
            PSTypeName = "DashboardPart"
            position   = @{ }
            metadata   = @{
              inputs = @(@{
                  name  = 'options'
                  value = @{
                    chart = @{
                      metrics          = $ExpectedMetrics
                      title            = $ExpectedTitle
                      visualization    = $ExpectedVisualization
                      openBladeOnClick = @{ }
                    }
                  }
                })
              type   = 'Extension/HubsExtension/PartType/MonitorChartPart'  
            }    
          }
        }
      ) {
        param(
          $Metrics,
          $Visualization,
          $Title,
          $Expected)               
        
        $actual = New-ArmDashboardsMonitorChart -Metrics $Metrics `
          -Visualization $Visualization `
          -Title $Title

        ($actual | ConvertTo-Json -Compress -Depth $Depth | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
        | Should -BeExactly ($Expected | ConvertTo-Json -Compress -Depth $Depth | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
      }     
    }

    Context "Integration tests" {
      It "Default" -Test {
        Invoke-IntegrationTest -ArmResourcesScriptBlock `
        {
          $Dashboards = New-ArmResourceName microsoft.portal/dashboards `
          | New-ArmDashboardsResource -Location 'centralus'

          $DashboardPart = New-ArmDashboardsMonitorChart -Metrics $ExpectedMetrics `
            -Visualization $ExpectedVisualization `
            -Title $ExpectedTitle
              
          Add-ArmDashboardsPartsElement -Dashboards $Dashboards -Part $DashboardPart `
          | Add-ArmResource
        }
      }
    }
  }
}

$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
  Describe "New-ArmDashboardsMonitorChart" {

    $ExpectedMetrics = @(@{value = "FirstMetric" }, @{ value = "SecondMetric" })
    $ExpectedVisualization = [PSCustomObject]@{ charType = 2; legendVisualization = @{ isVisible = $true } }
    $ExpectedTitle = "SomeTitle"

    Context "Unit tests" {
      It "Given valid parameters it returns '<Expected>'" -TestCases @(
        @{  
          Metrics       = $ExpectedMetrics
          Visualization = $ExpectedVisualization
          Title         = $ExpectedTitle
        }
      ) {
        param(
          $Metrics,
          $Visualization,
          $Title
        )
                
        $Expected = [PSCustomObject][ordered]@{
          PSTypeName = "DashboardPart"
          position   = @{ }
          metadata   = @{
            inputs = @(@{
                name  = 'options'
                value = @{
                  chart = @{
                    metrics          = $Metrics
                    title            = $Title
                    visualization    = $Visualization
                    openBladeOnClick = @{ }
                  }
                }
              })
            type   = 'Extension/HubsExtension/PartType/MonitorChartPart'  
          }    
        }
        
        $actual = New-ArmDashboardsMonitorChart -Metrics $Metrics `
          -Visualization $Visualization `
          -Title $Title

        ($actual | ConvertTo-Json -Compress -Depth 99 | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
        | Should -BeExactly ($Expected | ConvertTo-Json -Compress -Depth 99 | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
      }

      $ExpectedException = "MismatchedPSTypeName"

      Context "Integration tests" {
        It "Default" -Test {
          Invoke-IntegrationTest -ArmResourcesScriptBlock `
          {
            $Dashboards = New-ArmResourceName "microsoft.portal/dashboards" `
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
}

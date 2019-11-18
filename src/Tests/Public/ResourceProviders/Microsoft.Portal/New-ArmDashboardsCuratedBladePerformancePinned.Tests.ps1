$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
  Describe "New-ArmDashboardsCuratedBladePerformancePinned" {
    $InsightsResourceType = "microsoft.insights/components"
    $ExpectedLocation = "SomeLocation"
    $ApplicationInsights = New-ArmResourceName $InsightsResourceType `
    | New-ArmApplicationInsightsResource -Location $ExpectedLocation

    Context "Unit tests" {
      It "Given a '<ApplicationInsights>' it returns '<Expected>'" -TestCases @(
        @{ 
          ApplicationInsights = $ApplicationInsights     
          Expected            = [PSCustomObject][ordered]@{
            PSTypeName = "DashboardPart"
            position   = @{ }
            metadata   = @{
              inputs            = @( @{
                  name  = 'ResourceId'
                  value = $ApplicationInsights._ResourceId
                }, 
                @{
                  name       = 'DataModel'
                  value      = @{
                    version     = '1.0.0'
                    timeContext = @{
                      durationMs            = 86400000
                      endTime               = $null
                      createdTime           = '2018-05-04T01:20:33.345Z'
                      isInitialTime         = $false
                      grain                 = 1
                      useDashboardTimeRange = $false
                    }
                  }
                  isOptional = $true
                })
              type              = 'Extension/AppInsightsExtension/PartType/CuratedBladePerformancePinnedPart'
              isAdapter         = $true
              asset             = @{
                idInputName = 'ResourceId'
                type        = 'ApplicationInsights'
              }      
              defaultMenuItemId = 'performance'
            }      
          }
        }
      ) {
        param($ApplicationInsights, $Expected)

        $actual = New-ArmDashboardsCuratedBladePerformancePinned -ApplicationInsights $ApplicationInsights 
        ($actual | ConvertTo-Json -Depth 5 -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
        | Should -Be ($Expected | ConvertTo-Json -Depth 5 -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
      }     
    }
  }
}
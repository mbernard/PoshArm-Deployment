$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
  Describe "New-ArmDashboardsAspNetOverviewPinned" {
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
              inputs            = @(@{
                  name  = 'id'
                  value = $ApplicationInsights._ResourceId
                }, @{
                  name  = 'Version'
                  value = '1.0'
                })
              type              = 'Extension/AppInsightsExtension/PartType/AspNetOverviewPinnedPart'
              asset             = @{
                idInputName = 'id'
                type        = 'ApplicationInsights'
              }
              defaultMenuItemId = 'overview'
            }      
          }
        }
      ) {
        param($ApplicationInsights, $Expected)

        $actual = New-ArmDashboardsAspNetOverviewPinned -ApplicationInsights $ApplicationInsights 
        ($actual | ConvertTo-Json -Depth 3 -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
        | Should -Be ($Expected | ConvertTo-Json -Depth 3 -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
      }     
    }
  }
}
$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
  Describe "New-ArmDashboardsApplicationMap" {
    $InsightsResourceType = "microsoft.insights/components"
    $ExpectedLocation = "SomeLocation"
    $ApplicationInsights = New-ArmResourceName $InsightsResourceType `
    | New-ArmApplicationInsightsResource -Location $ExpectedLocation

    Context "Unit tests" {
      It "Given a '<ApplicationInsights>', '<SubscriptionId>', '<ResourceGroupName>' it returns '<Expected>'" -TestCases @(
        @{ 
          ApplicationInsights = $ApplicationInsights
          SubscriptionId      = 'subscription-id'
          ResourceGroupName   = 'resource-group-name'         
          Expected            = [PSCustomObject][ordered]@{
            PSTypeName = "DashboardPart"
            position   = @{ }
            metadata   = @{
              inputs = @(@{
                  name  = 'ComponentId'
                  value = @{
                    Name           = $ApplicationInsights.Name
                    SubscriptionId = 'subscription-id'
                    ResourceGroup  = 'resource-group-name'
                  }
                }, 
                @{
                  name  = 'TimeContext'
                  value = @{
                    durationMs            = 86400000
                    endTime               = $null
                    createdTime           = '2018-05-04T01:20:33.345Z'
                    isInitialTime         = $true
                    grain                 = 1
                    useDashboardTimeRange = $false
                  }
                })
              type   = 'Extension/AppInsightsExtension/PartType/ApplicationMapPart'
              asset  = @{
                idInputName = 'ComponentId'
                type        = 'ApplicationInsights'
              }      
            }      
          }
        }
      ) {
        param($ApplicationInsights, $SubscriptionId, $ResourceGroupName, $Expected)

        $actual = New-ArmDashboardsApplicationMap -ApplicationInsights $ApplicationInsights -SubscriptionId $SubscriptionId -ResourceGroupName $ResourceGroupName
        ($actual | ConvertTo-Json -Depth 4 -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
        | Should -Be ($Expected | ConvertTo-Json -Depth 4 -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
      }     
    }
  }
}
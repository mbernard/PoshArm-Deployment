$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
  Describe "New-ArmDashboardsApplicationMap" {
    $Depth = 4
    $ApplicationInsights = New-ArmResourceName "microsoft.insights/components" `
    | New-ArmApplicationInsightsResource -Location "SomeLocation"

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
                    createdTime           = $null
                    isInitialTime         = $false
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
        [datetime]::Parse($actual.metadata.inputs[1].value.createdTime) - (Get-Date) | Should -BeLessThan ([TimeSpan]::FromSeconds(10))
        $actual.metadata.inputs[1].value.createdTime = $null

        ($actual | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
        | Should -Be ($Expected | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
      }     
    }
  }
}
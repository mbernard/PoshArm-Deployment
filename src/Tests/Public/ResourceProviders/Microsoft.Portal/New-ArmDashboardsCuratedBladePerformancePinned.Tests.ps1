$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
  Describe "New-ArmDashboardsCuratedBladePerformancePinned" {
    $Depth = 5
    $ApplicationInsights = New-ArmResourceName "microsoft.insights/components" `
    | New-ArmApplicationInsightsResource -Location "SomeLocation"

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
                      createdTime           = $null
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
        [datetime]::Parse($actual.metadata.inputs[1].value.timeContext.createdTime) - (Get-Date) | Should -BeLessThan ([TimeSpan]::FromSeconds(5))
        $actual.metadata.inputs[1].value.timeContext.createdTime = $null
        ($actual | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
        | Should -Be ($Expected | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
      }     
    }
  }
}
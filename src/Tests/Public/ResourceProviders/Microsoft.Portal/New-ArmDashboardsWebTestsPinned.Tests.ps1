$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
  Describe "New-ArmDashboardsWebTestsPinned" {
    $Depth = 99
    $ExpectedResourceName = 'SomeApplicationInsight'
    BeforeEach {
      $ApplicationInsights = New-ArmApplicationInsightsResource -Name $ExpectedResourceName
      $Expected = New-ArmApplicationInsightsResource -Name $ExpectedResourceName
    }

    $ExpectedSubscriptionId = "SomeId"
    $ExpectedResourceGroupName = "SomeResourceGroup"
    
    Context "Unit tests" {
      It "Given valid ApplicationInsights object it returns '<Expected>'" -TestCases @(
        @{  
          SubscriptionId    = $ExpectedSubscriptionId
          ResourceGroupName = $ExpectedResourceGroupName
        }
      ) {
        param(
          $SubscriptionId,
          $ResourceGroupName
        )
                
        $Expected = [PSCustomObject][ordered]@{
          PSTypeName = "DashboardPart"
          position   = @{ }
          metadata   = @{
            inputs = @(@{
                name  = 'ComponentId'
                value = @{
                  Name           = $ExpectedResourceName
                  SubscriptionId = $SubscriptionId
                  ResourceGroup  = $ResourceGroupName
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
              },
              @{
                name  = 'Version'
                value = '1.0'
              },
              @{
                name       = 'componentId'
                isOptional = $true
              },
              @{
                name       = 'id'
                isOptional = $true
              })
            type   = 'Extension/AppInsightsExtension/PartType/WebTestsPinnedPart'
            asset  = @{
              idInputName = 'ComponentId'
              type        = 'ApplicationInsights'
            }
          }      
        }
        

        $actual = New-ArmDashboardsWebTestsPinned -ApplicationInsights $ApplicationInsights `
          -SubscriptionId $SubscriptionId `
          -ResourceGroupName $ResourceGroupName

        [datetime]::Parse($actual.metadata.inputs[1].value.createdTime) - (Get-Date) | Should -BeLessThan ([TimeSpan]::FromSeconds(5))
        $actual.metadata.inputs[1].value.createdTime = $null

        ($actual | ConvertTo-Json -Compress -Depth $Depth | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
        | Should -BeExactly ($Expected | ConvertTo-Json -Compress -Depth $Depth | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
      }


      $ExpectedException = "MismatchedPSTypeName"

      It "Given an invalid Application Insight, it throws '<Expected>'" -TestCases @(
        @{ ApplicationInsights = "ApplicationInsights"
          Expected             = $ExpectedException
        }
        @{ ApplicationInsights = [PSCustomObject]@{Name = "Value" }
          Expected             = $ExpectedException
        }
      ) { param($ApplicationInsights, $Expected)
        { New-ArmDashboardsWebTestsPinned -ApplicationInsights $ApplicationInsights `
            -SubscriptionId $ExpectedSubscriptionId `
            -ResourceGroupName $ExpectedResourceGroupName } | Should -Throw -ErrorId $Expected
      }

      Context "Integration tests" {
        It "Default" -Test {
          Invoke-IntegrationTest -ArmResourcesScriptBlock `
          {
            $Dashboards = New-ArmResourceName "microsoft.portal/dashboards" `
            | New-ArmDashboardsResource -Location 'centralus'

            $DashboardPart = New-ArmDashboardsWebTestsPinned -ApplicationInsights $ApplicationInsights `
              -SubscriptionId $ExpectedSubscriptionId `
              -ResourceGroupName $ExpectedResourceGroupName
              
            Add-ArmDashboardsPartsElement -Dashboards $Dashboards -Part $DashboardPart `
            | Add-ArmResource
          }
        }
      }
    }
  }
}

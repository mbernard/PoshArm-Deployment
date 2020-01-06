$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
  Describe "New-ArmDashboardsAnalyticsChart" {
    $Depth = 6
    $ApplicationInsights = New-ArmResourceName "microsoft.insights/components" `
    | New-ArmApplicationInsightsResource -Location "SomeLocation"

    Context "Unit tests" {
      It "Given a '<Source>', '<SubscriptionId>', '<ResourceGroupName>', '<Query>', '<Dimensions>', '<ResourceType>',
       '<ChartType>', '<Title>', '<SubTitle>' it returns '<Expected>'" -TestCases @(
        @{ 
          Source            = $ApplicationInsights
          SubscriptionId    = 'subscription-id'
          ResourceGroupName = 'resource-group-name'
          Query             = 'test query'
          Dimensions        = @{ 
            xAxis       = @{
              name = 'TimeGenerated'
              type = 'datetime' 
            } 
            yAxis       = @(
              @{
                name = 'sum_Count'
                type = 'long' 
              }) 
            splitBy     = @()
            aggregation = 'Sum'
          }
          ResourceType      = 'resource-type'
          ChartType         = 'chart-type'
          Title             = 'title'
          SubTitle          = 'sub-title'          
          Expected          = [PSCustomObject][ordered]@{
            PSTypeName = "DashboardPart"
            position   = @{ }
            metadata   = @{
              inputs = @(@{
                  name  = 'ComponentId'
                  value = @{
                    Name           = $ApplicationInsights.Name
                    SubscriptionId = 'subscription-id'
                    ResourceGroup  = 'resource-group-name'
                    ResourceId     = $ApplicationInsights._ResourceId
                  }
                }, @{
                  name  = 'Query'
                  value = 'test query'
                }, 
                @{
                  name  = 'Dimensions'
                  value = @{ 
                    xAxis       = @{
                      name = 'TimeGenerated'
                      type = 'datetime' 
                    } 
                    yAxis       = @(
                      @{
                        name = 'sum_Count'
                        type = 'long' 
                      }) 
                    splitBy     = @()
                    aggregation = 'Sum'
                  }
                }, 
                @{
                  name  = 'Version'
                  value = 'v1.0'
                },
                @{
                  name  = 'PartTitle'
                  value = 'title'
                }, @{
                  name  = 'PartSubTitle'
                  value = 'sub-title'
                }, @{
                  name  = 'resourceTypeMode'
                  value = 'resource-type'
                }, @{
                  name  = 'ControlType'
                  value = 'AnalyticsChart'
                }, @{
                  name  = 'SpecificChart'
                  value = 'chart-type'
                })
              type   = 'Extension/AppInsightsExtension/PartType/AnalyticsPart'
              asset  = @{
                idInputName = 'ComponentId'
                type        = 'ApplicationInsights'
              }
            }      
          }
        }
      ) {
        param($Source, $SubscriptionId, $ResourceGroupName, $Query, $Dimensions, $ResourceType, $ChartType, $Title, $SubTitle, $Expected)

        $actual = New-ArmDashboardsAnalyticsChart -Source $Source -SubscriptionId $SubscriptionId -ResourceGroupName $ResourceGroupName -Query $Query `
          -Dimensions $Dimensions -ResourceType $ResourceType -ChartType $ChartType -Title $Title -SubTitle $SubTitle
        ($actual | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
        | Should -Be ($Expected | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
      }     
    }
  }
}
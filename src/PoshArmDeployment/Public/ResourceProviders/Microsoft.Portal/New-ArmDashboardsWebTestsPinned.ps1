function New-ArmDashboardsWebTestsPinned {
  [CmdletBinding(SupportsShouldProcess = $true)]
  [OutputType("DashboardPart")]
  Param(
    [PSTypeName("ApplicationInsights")]
    [Parameter(Mandatory)]
    $ApplicationInsights,
    [string]
    [Parameter(Mandatory)]
    $SubscriptionId,
    [string]
    [Parameter(Mandatory)]
    $ResourceGroupName
  )

  If ($PSCmdlet.ShouldProcess("Adding WebTestsPinnedPart to Dashboards")) {
    $ApplicationInsightsResourceName = $ApplicationInsights.Name
    $WebTests = [PSCustomObject][ordered]@{
      PSTypeName = "DashboardPart"
      position   = @{ }
      metadata   = @{
        inputs = @(@{
            name  = 'ComponentId'
            value = @{
              Name           = $ApplicationInsightsResourceName
              SubscriptionId = $SubscriptionId
              ResourceGroup  = $ResourceGroupName
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
    return $WebTests
  }  
}
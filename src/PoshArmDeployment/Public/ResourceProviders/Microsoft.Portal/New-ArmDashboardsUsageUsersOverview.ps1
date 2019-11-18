function New-ArmDashboardsUsageUsersOverview {
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

  If ($PSCmdlet.ShouldProcess("Adding UsageUsersOverviewPart to Dashboards")) {
    $ApplicationInsightsResourceName = $ApplicationInsights.Name
    $UsageUserOverview = [PSCustomObject][ordered]@{
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
              isInitialTime         = $false
              grain                 = 1
              useDashboardTimeRange = $false
            }
          })
        type   = 'Extension/AppInsightsExtension/PartType/UsageUsersOverviewPart'
        asset  = @{
          idInputName = 'ComponentId'
          type        = 'ApplicationInsights'
        }
      }      
    }
    return $UsageUserOverview
  }  
}
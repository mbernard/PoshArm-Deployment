function New-ArmDashboardsApplicationMap {
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

  If ($PSCmdlet.ShouldProcess("Adding ApplicationMapPart to Dashboards")) {
    $Now = Get-Date
    $ApplicationInsightsResourceName = $ApplicationInsights.Name
    $ApplicationMap = [PSCustomObject][ordered]@{
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
              createdTime           = $Now.ToUniversalTime().ToString('O')
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
    return $ApplicationMap
  }  
}
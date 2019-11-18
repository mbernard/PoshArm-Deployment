function New-ArmDashboardsQuickPulseButtonSmall {
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

  If ($PSCmdlet.ShouldProcess("Adding QuickPulseButtonSmallPart to Dashboards")) {
    $ApplicationInsightsResourceName = $ApplicationInsights.Name
    $ApplicationInsightsResourceId = $ApplicationInsights._ResourceId
    $QuickPulse = [PSCustomObject][ordered]@{
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
          }, @{
            name  = 'ResourceId'
            value = $ApplicationInsightsResourceId
          })
        type   = 'Extension/AppInsightsExtension/PartType/QuickPulseButtonSmallPart'
        asset  = @{
          idInputName = 'ComponentId'
          type        = 'ApplicationInsights'
        }
      }      
    }
    return $QuickPulse
  }  
}
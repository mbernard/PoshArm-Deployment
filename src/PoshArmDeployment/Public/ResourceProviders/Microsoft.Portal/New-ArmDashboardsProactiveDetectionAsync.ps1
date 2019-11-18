function New-ArmDashboardsProactiveDetectionAsync {
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

  If ($PSCmdlet.ShouldProcess("Adding ProactiveDetectionAsyncPart to Dashboards")) {
    $ApplicationInsightsResourceName = $ApplicationInsights.Name
    $ProactiveDetection = [PSCustomObject][ordered]@{
      PSTypeName = "DashboardPart"
      position   = @{ }
      metadata   = @{
        inputs            = @(@{
            name  = 'ComponentId'
            value = @{
              Name           = $ApplicationInsightsResourceName
              SubscriptionId = $SubscriptionId
              ResourceGroup  = $ResourceGroupName
            }
          }, @{
            name  = 'Version'
            value = '1.0'
          })
        type              = 'Extension/AppInsightsExtension/PartType/ProactiveDetectionAsyncPart'
        asset             = @{
          idInputName = 'ComponentId'
          type        = 'ApplicationInsights'
        }
        defaultMenuItemId = 'ProactiveDetection'
      }      
    }
    return $ProactiveDetection
  }  
}
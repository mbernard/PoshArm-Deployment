function New-ArmDashboardsAspNetOverviewPinned {
  [CmdletBinding(SupportsShouldProcess = $true)]
  [OutputType("DashboardPart")]
  Param(
    [PSTypeName("ApplicationInsights")]
    [Parameter(Mandatory)]
    $ApplicationInsights      
  )

  If ($PSCmdlet.ShouldProcess("Adding AspNetOverviewPinnedPart to Dashboards")) {
    $ApplicationInsightsResourceId = $ApplicationInsights._ResourceId
    $AspNetOverview = [PSCustomObject][ordered]@{
      PSTypeName = "DashboardPart"
      position   = @{ }
      metadata   = @{
        inputs            = @(@{
            name  = 'id'
            value = $ApplicationInsightsResourceId
          }, @{
            name  = 'Version'
            value = '1.0'
          })
        type              = 'Extension/AppInsightsExtension/PartType/AspNetOverviewPinnedPart'
        asset             = @{
          idInputName         = 'id'
          type                = 'ApplicationInsights'
        }
        defaultMenuItemId = 'overview'
      }      
    }
    return $AspNetOverview
  }  
}
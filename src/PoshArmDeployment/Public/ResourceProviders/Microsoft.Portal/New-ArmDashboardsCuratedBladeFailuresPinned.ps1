function New-ArmDashboardsCuratedBladeFailuresPinned {
  [CmdletBinding(SupportsShouldProcess = $true)]
  [OutputType("DashboardPart")]
  Param(
    [PSTypeName("ApplicationInsights")]
    [Parameter(Mandatory)]
    $ApplicationInsights
  )

  If ($PSCmdlet.ShouldProcess("Adding CuratedBladeFailuresPinnedPart to Dashboards")) {
    $ApplicationInsightsResourceId = $ApplicationInsights._ResourceId
    $CuratedBlade = [PSCustomObject][ordered]@{
      PSTypeName = "DashboardPart"
      position   = @{ }
      metadata   = @{
        inputs            = @( @{
            name  = 'ResourceId'
            value = $ApplicationInsightsResourceId
          }, 
          @{
            name       = 'DataModel'
            value      = @{
              version     = '1.0.0'
              timeContext = @{
                durationMs            = 86400000
                endTime               = $null
                createdTime           = '2018-05-04T01:20:33.345Z'
                isInitialTime         = $false
                grain                 = 1
                useDashboardTimeRange = $false
              }
            }
            isOptional = $true
          })
        type              = 'Extension/AppInsightsExtension/PartType/CuratedBladeFailuresPinnedPart'
        isAdapter         = $true
        asset             = @{
          idInputName = 'ComponentId'
          type        = 'ApplicationInsights'
        }      
        defaultMenuItemId = 'failures'
      }      
    }
    return $CuratedBlade
  }  
}
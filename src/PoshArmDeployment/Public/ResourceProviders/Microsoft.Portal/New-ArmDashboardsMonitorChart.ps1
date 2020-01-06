function New-ArmDashboardsMonitorChart {
  [CmdletBinding(SupportsShouldProcess = $true)]
  [OutputType("DashboardPart")]
  Param(
    [PSTypeName("ChartMetric")][object[]]
    [Parameter(Mandatory)]
    $Metrics,
    [PSTypeName("ChartVisualization")]
    [Parameter(Mandatory)]
    $Visualization,
    [string]
    [Parameter(Mandatory)]
    $Title,
    [PSCustomObject]
    $OpenBladeOnClick = @{ }
  )

  If ($PSCmdlet.ShouldProcess("Adding MonitorChartPart to Dashboards")) {
    $MonitorChart = [PSCustomObject][ordered]@{
      PSTypeName = "DashboardPart"
      position   = @{ }
      metadata   = @{
        inputs = @(@{
            name  = 'options'
            value = @{
              chart = @{
                metrics          = $Metrics
                title            = $Title
                visualization    = $Visualization
                openBladeOnClick = $OpenBladeOnClick
              }
            }
          })
        type   = 'Extension/HubsExtension/PartType/MonitorChartPart'  
      }    
    }
    return $MonitorChart
  }  
}
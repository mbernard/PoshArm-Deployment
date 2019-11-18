function New-ArmDashboardsAnalyticsChart {
  [CmdletBinding(SupportsShouldProcess = $true)]
  [OutputType("DashboardPart")]
  Param(
    [PSCustomObject]
    [Parameter(Mandatory)]
    $Source,
    [string]
    [Parameter(Mandatory)]
    $SubscriptionId,
    [string]
    [Parameter(Mandatory)]
    $ResourceGroupName,
    [string]
    [Parameter(Mandatory)]
    $Query,
    [PSObject]
    [Parameter(Mandatory)]
    $Dimensions,
    [string]
    [Parameter(Mandatory)]
    $ResourceType,
    [string]
    [Parameter(Mandatory)]
    $ChartType,
    [string]
    $Title = '',
    [string]
    $SubTitle = ''
  )

  If ($PSCmdlet.ShouldProcess("Adding AnalyticsChartsPart to Dashboards")) {
    $SourceResourceName = $Source.Name
    $SourceResourceId = $Source._ResourceId
    $QuickPulse = [PSCustomObject][ordered]@{
      PSTypeName = "DashboardPart"
      position   = @{ }
      metadata   = @{
        inputs = @(@{
            name  = 'ComponentId'
            value = @{
              Name           = $SourceResourceName
              SubscriptionId = $SubscriptionId
              ResourceGroup  = $ResourceGroupName
              ResourceId     = $SourceResourceId
            }
          }, @{
            name  = 'Query'
            value = $Query
          }, @{
            name  = 'Dimensions'
            value = $Dimensions
          }, @{
            name  = 'Version'
            value = 'v1.0'
          },
          @{
            name  = 'PartTitle'
            value = $Title
          }, @{
            name  = 'PartSubTitle'
            value = $SubTitle
          }, @{
            name  = 'resourceTypeMode'
            value = $ResourceType
          }, @{
            name  = 'ControlType'
            value = 'AnalyticsChart'
          }, @{
            name  = 'SpecificChart'
            value = $ChartType
          })
        type   = 'Extension/AppInsightsExtension/PartType/AnalyticsPart'
        asset  = @{
          idInputName = 'ComponentId'
          type        = 'ApplicationInsights'
        }
      }      
    }
    return $QuickPulse
  }  
}
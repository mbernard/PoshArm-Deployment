function New-AnalyticsChartDimension {
  [CmdletBinding(SupportsShouldProcess = $true)]
  [OutputType("ChartDimension")]
  param(
    [Parameter(Mandatory)]
    [string]
    $XName,
    [Parameter(Mandatory)]
    [string]
    $XType,
    [Parameter(Mandatory)]
    [string]
    $YName,
    [Parameter(Mandatory)]
    [string]
    $YType,
    [Parameter(Mandatory)]
    [string]
    $Aggregation)
  Process {
    If ($PSCmdlet.ShouldProcess("Creating dimension for analytics chart")) {
      $dimension = [PSCustomObject][ordered]@{ 
        PSTypeName  = "ChartDimension"
        xAxis       = @{ 
          name = $XName
          type = $XType
        }
        yAxis       = @(
          @{
            name = $YName
            type = $YType
          })
        splitBy     = @(); 
        aggregation = $Aggregation
      }      

      return $dimension
    }
  }
}
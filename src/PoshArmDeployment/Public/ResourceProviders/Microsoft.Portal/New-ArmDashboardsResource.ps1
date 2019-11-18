function New-ArmDashboardsResource {
  [CmdletBinding(SupportsShouldProcess = $true)]
  [OutputType("Dashboards")]
  Param(
    [Parameter(Mandatory, ValueFromPipeline)]
    [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
    [string]
    $Name,
    [string]
    $ApiVersion = '2015-08-01-preview',
    [string]
    $Location = $script:Location
  )

  If ($PSCmdlet.ShouldProcess("Creates a new Arm Dashboard resource")) {
    $DashboardResourceId = $Name | New-ArmFunctionResourceId -ResourceType 'microsoft.portal/dashboards'
    $Dashboards = [PSCustomObject][ordered]@{
      _ResourceId = $DashboardResourceId
      PSTypeName  = "Dashboards"
      type        = 'microsoft.portal/dashboards'
      name        = $Name
      apiVersion  = $ApiVersion
      location    = $Location
      metadata    = @{ }
      properties  = [PSCustomObject]@{ 
        lenses = [PSCustomObject]@{
          0 = [PSCustomObject]@{ 
            order = 0
            parts = [PSCustomObject]@{ }
          }
        }
      }
      resources   = @()
      dependsOn   = @()
    }
    
    $Dashboards.PSTypeNames.Add("ArmResource")
    return $Dashboards
  }
}
function Add-ArmDashboardsPartsElement {
  [CmdletBinding(SupportsShouldProcess = $true)]
  [OutputType("Dashboards")]
  Param(
    [PSTypeName("DashboardPart")]
    [Parameter(Mandatory)]
    $Part,
    [PSTypeName("Dashboards")]
    [Parameter(Mandatory)]
    $Dashboards
  )
  If ($PSCmdlet.ShouldProcess("Adding DashboardPart to Dashboards")) {
    $index = ($Dashboards.properties.lenses.'0'.parts | Get-Member -View Extended).count 
    $Dashboards.properties.lenses.'0'.parts | Add-Member -MemberType NoteProperty -Name $index.ToString() -Value $Part
    return $Dashboards
  }  
}
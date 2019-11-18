function Set-ArmDashboardsPartsPosition {
  [CmdletBinding(SupportsShouldProcess = $true)]
  [OutputType("DashboardPart")]
  Param(
    [PSTypeName("DashboardPart")]
    [Parameter(Mandatory, ValueFromPipeline)]
    $Part,
    [int]
    $XPosition = 0,   
    [int]
    $YPosition = 0, 
    [int]
    $ColSpan = 0, 
    [int]
    $RowSpan = 0   
  )

  If ($PSCmdlet.ShouldProcess("Setting position to DashboardPart")) {
    $Part.position = [PSCustomObject]@{
      x       = $XPosition
      y       = $YPosition
      colSpan = $ColSpan
      rowSpan = $RowSpan 
    }
    return $Part
  }
}
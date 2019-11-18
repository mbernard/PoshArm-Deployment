function New-ArmDashboardsMarkdown {
  [CmdletBinding(SupportsShouldProcess = $true)]
  [OutputType("DashboardPart")]
  Param(
    [string]
    $Content = '',
    [string]
    $Title = '',
    [string]
    $Subtitle = ''
  )

  If ($PSCmdlet.ShouldProcess("Adding MarkdownPart to Dashboards")) {
    $Markdown = [PSCustomObject][ordered]@{
      PSTypeName = "DashboardPart"
      position   = @{ }
      metadata   = @{
        inputs   = @()
        type     = 'Extension/HubsExtension/PartType/MarkdownPart'
        settings = @{
          content = @{
            settings = @{
              content  = $Content
              title    = $Title
              subtitle = $Subtitle
            }
          }      
        }
      }      
    }
    return $Markdown
  }  
}
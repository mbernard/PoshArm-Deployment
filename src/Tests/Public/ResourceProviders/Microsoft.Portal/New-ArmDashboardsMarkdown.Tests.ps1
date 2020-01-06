$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
  Describe "New-ArmDashboardsMarkdown" {
    $Depth = 4
    Context "Unit tests" {
      It "Given a '<Content>', '<Title>', '<Subtitle>' it returns '<Expected>'" -TestCases @(
        @{ 
          Content  = 'test content'     
          Title    = 'test title'  
          Subtitle = 'test subtitle'  
          Expected = [PSCustomObject][ordered]@{
            PSTypeName = "DashboardPart"
            position   = @{ }
            metadata   = @{
              inputs   = @()
              type     = 'Extension/HubsExtension/PartType/MarkdownPart'
              settings = @{
                content = @{
                  settings = @{
                    content  = 'test content'    
                    title    = 'test title'  
                    subtitle = 'test subtitle'  
                  }
                }      
              }
            }      
          }
        }
      ) {
        param($Content, $Title, $Subtitle, $Expected)

        $actual = New-ArmDashboardsMarkdown -Content $Content -Title $Title -Subtitle $Subtitle
        ($actual | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
        | Should -Be ($Expected | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
      }     
    }
  }
}
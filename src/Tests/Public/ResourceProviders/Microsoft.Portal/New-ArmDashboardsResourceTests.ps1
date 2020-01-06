$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
  Describe "New-ArmDashboardsResource" {
    $Depth = 99
    $ResourceType = 'microsoft.portal/dashboards'
    BeforeEach {
      $ResourceName = New-ArmResourceName $ResourceType `
    }

    $ExpectedApiVersion = "SomeApiVersion"
    $ExpectedLocation = "canadacentral"
    
    Context "Unit tests" {
      It "Given valid resource name it returns '<Expected>'" -TestCases @(
        @{  
          ApiVersion = $ExpectedApiVersion
          Location   = $ExpectedLocation
        }
      ) {
        param(
          $ApiVersion,
          $Location
        )
                
        $ExpectedDashboardResourceId = $ResourceName | New-ArmFunctionResourceId -ResourceType 'microsoft.portal/dashboards'
        $Expected = [PSCustomObject][ordered]@{
          _ResourceId = $ExpectedDashboardResourceId
          PSTypeName  = "Dashboards"
          type        = 'microsoft.portal/dashboards'
          name        = $ResourceName
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
        
        $actual = $ResourceName | New-ArmDashboardsResource -ApiVersion $ApiVersion -Location $Location

        ($actual | ConvertTo-Json -Compress -Depth $Depth | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
        | Should -BeExactly ($Expected | ConvertTo-Json -Compress -Depth $Depth | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
      }

      Context "Integration tests" {
        It "Default" -Test {
          Invoke-IntegrationTest -ArmResourcesScriptBlock `
          {
            $ResourceName | New-ArmDashboardsResource -ApiVersion $ExpectedApiVersion -Location $ExpectedLocation `
            | Add-ArmResource
          }
        }
      }
    }
  }
}

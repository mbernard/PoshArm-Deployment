$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
  Describe "Set-ArmDashboardsPartsPosition" {

    BeforeEach {
      $DashboardPart = [PSCustomObject][ordered]@{
        PSTypeName = "DashboardPart"
        position   = @{ }    
      }
      $Expected = [PSCustomObject][ordered]@{
        PSTypeName = "DashboardPart"
        position   = @{ }    
      }
    }

    $ExpectedY = 1
    $ExpectedX = 1
    $ExpectedColSpan = 1
    $ExpectedRowSpan = 1
    
    Context "Unit tests" {
      It "Given valid DashboardPart it returns '<Expected>'" -TestCases @(
        @{  
          X       = $ExpectedX
          Y       = $ExpectedY
          ColSpan = $ExpectedColSpan
          RowSpan = $ExpectedRowSpan
        }
      ) {
        param(
          $X,
          $Y ,
          $ColSpan ,
          $RowSpan 
        )
                
        $Expected.position = [PSCustomObject]@{
          x       = $X
          y       = $Y
          colSpan = $ColSpan
          rowSpan = $RowSpan
        }

        $actual = $DashboardPart | Set-ArmDashboardsPartsPosition -XPosition $X `
          -YPosition $Y `
          -ColSpan $ColSpan `
          -RowSpan $RowSpan

        ($actual | ConvertTo-Json -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
        | Should -BeExactly ($Expected | ConvertTo-Json -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
      }


      $ExpectedException = "MismatchedPSTypeName"

      It "Given an invalid Dashboard Part, it throws '<Expected>'" -TestCases @(
        @{ DashboardPart = "DashboardPart"
          Expected       = $ExpectedException
        }
        @{ DashboardPart = [PSCustomObject]@{Name = "Value" }
          Expected       = $ExpectedException
        }
      ) { param($DashboardPart, $Expected)
        { Set-ArmDashboardsPartsPosition -Part $DashboardPart } | Should -Throw -ErrorId $Expected
      }

      Context "Integration tests" {
        It "Default" -Test {
          Invoke-IntegrationTest -ArmResourcesScriptBlock `
          {
            $Dashboards = New-ArmResourceName "microsoft.portal/dashboards" `
            | New-ArmDashboardsResource -Location 'centralus'

            $DashboardPart = Set-ArmDashboardsPartsPosition -Part $DashboardPart
            Add-ArmDashboardsPartsElement -Dashboards $Dashboards -Part $DashboardPart `
            | Add-ArmResource
          }
        }
      }
    }
  }
}

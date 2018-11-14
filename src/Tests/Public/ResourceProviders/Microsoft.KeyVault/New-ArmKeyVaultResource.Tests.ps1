$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
    Describe "New-ArmKeyVaultResource" {
        It "Given a '<Name>', it returns '<Expected>'" -TestCases @(
            @{ Name = "name1"; Expected = [PSCustomObject][ordered]@{
                    _ResourceId = "[resourceId('Microsoft.KeyVault/vaults','name1')]"
                    type        = 'Microsoft.KeyVault/vaults'
                    name        = "name1"
                    apiVersion  = "2016-10-01"
                    location    = ""
                    properties  = @{
                        sku                          = @{
                            name   = "standard"
                            family = "A"
                        }
                        tenantId                     = "[subscription().tenantId]"
                        accessPolicies               = @()
                        enabledForDeployment         = $false
                        enabledForTemplateDeployment = $false
                        enabledForDiskEncryption     = $false
                    }
                    resources   = @()
                    dependsOn   = @()
                }
            }
        ) {
            param($Name, $Expected)

            $actual = $Name | New-ArmKeyVaultResource
            ($actual | ConvertTo-Json -Compress| ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) | Should -Be ($Expected | ConvertTo-Json -Compress| % { [System.Text.RegularExpressions.Regex]::Unescape($_) })
        }
    }
}
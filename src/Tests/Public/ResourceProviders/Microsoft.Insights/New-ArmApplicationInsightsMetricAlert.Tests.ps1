$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
        Describe "New-ArmApplicationInsightsMetricAlert" {
            Context "Unit tests" {
                $ResourceType = "Microsoft.Insights/metricAlerts"
                $expectedName = "name1"
                It "Given a '<Name>', it returns '<Expected>'" -TestCases @(
                    @{ Name = $expectedName; Expected = [PSCustomObject][ordered]@{
                            _ResourceId = $expectedName | New-ArmFunctionResourceId -ResourceType $ResourceType
                            type        = $ResourceType
                            name        = $expectedName
                            apiVersion  = "2018-03-01"
                            location    = 'global'
                            properties  = @{
                                description         = ""
                                severity            = 3
                                enabled             = $true
                                scopes              = @()
                                evaluationFrequency = "PT1M"
                                windowSize          = "PT5M"
                                criteria            = @{
                                    allOf               = @()
                                }
                                actions             = @()
                            }
                            dependsOn   = @()
                        }
                    }
                ) {
                    param($Name, $Expected)
    
                    $actual = $Name | New-ArmApplicationInsightsMetricAlert
                    ($actual | ConvertTo-Json -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                        | Should -Be ($Expected | ConvertTo-Json -Compress| ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
                }
            }
        }
    }
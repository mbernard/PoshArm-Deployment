$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
    Describe "Add-ArmDashboardsPartsElement" {
        $Depth = 9
        Context "Unit tests" {
            It "Given a dashboard with no parts and '<Part>', it returns '<Expected>' with one element" -TestCases @(
                @{ Dashboard = [PSCustomObject][ordered]@{
                        _ResourceId = $DashboardResourceId
                        PSTypeName  = "Dashboards"
                        type        = 'microsoft.portal/dashboards'
                        name        = 'name1'
                        apiVersion  = 'Version 1.0'
                        location    = 'test-location'
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
                    }; 
                    Part     = [PSCustomObject][ordered]@{
                        PSTypeName = "DashboardPart"
                        position   = @{ }
                        metadata   = @{
                            inputs   = @()
                            type     = 'Extension/HubsExtension/PartType/MarkdownPart'
                            settings = @{
                                content = @{
                                    settings = @{
                                        content  = ''
                                        title    = 'Test part'
                                        subtitle = ''
                                    }
                                }      
                            }
                        }      
                    };
                    Expected = [PSCustomObject][ordered]@{
                        _ResourceId = $DashboardResourceId
                        PSTypeName  = "Dashboards"
                        type        = 'microsoft.portal/dashboards'
                        name        = 'name1'
                        apiVersion  = 'Version 1.0'
                        location    = 'test-location'
                        metadata    = @{ }
                        properties  = [PSCustomObject]@{ 
                            lenses = [PSCustomObject]@{
                                0 = [PSCustomObject]@{ 
                                    order = 0
                                    parts = [PSCustomObject]@{ 
                                        0 = [PSCustomObject][ordered]@{
                                            PSTypeName = "DashboardPart"
                                            position   = @{ }
                                            metadata   = @{
                                                inputs   = @()
                                                type     = 'Extension/HubsExtension/PartType/MarkdownPart'
                                                settings = @{
                                                    content = @{
                                                        settings = @{
                                                            content  = ''
                                                            title    = 'Test part'
                                                            subtitle = ''
                                                        }
                                                    }      
                                                }
                                            }      
                                        }
                                    }
                                }
                            }
                        }
                        resources   = @()
                        dependsOn   = @()
                    }
                }
            ) {
                param($Dashboard, $Part, $Expected)

                $actual = Add-ArmDashboardsPartsElement -Dashboards $Dashboard -Part $Part
                ($actual | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                | Should -Be ($Expected | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
            }
            It "Given a dashboard with parts and '<Part>', it returns '<Expected>' with one more part" -TestCases @(
                @{ Dashboard = [PSCustomObject][ordered]@{
                        _ResourceId = $DashboardResourceId
                        PSTypeName  = "Dashboards"
                        type        = 'microsoft.portal/dashboards'
                        name        = 'name1'
                        apiVersion  = 'Version 1.0'
                        location    = 'test-location'
                        metadata    = @{ }
                        properties  = [PSCustomObject]@{ 
                            lenses = [PSCustomObject]@{
                                0 = [PSCustomObject]@{ 
                                    order = 0
                                    parts = [PSCustomObject]@{ 0 = [PSCustomObject][ordered]@{
                                            PSTypeName = "DashboardPart"
                                            position   = @{ }
                                            metadata   = @{
                                                inputs   = @()
                                                type     = 'Extension/HubsExtension/PartType/MarkdownPart'
                                                settings = @{
                                                    content = @{
                                                        settings = @{
                                                            content  = ''
                                                            title    = 'Test part'
                                                            subtitle = ''
                                                        }
                                                    }      
                                                }
                                            }      
                                        }
                                    }
                                }
                            }
                        }
                        resources   = @()
                        dependsOn   = @()
                    }; Part  = [PSCustomObject][ordered]@{
                        PSTypeName = "DashboardPart"
                        position   = @{ }
                        metadata   = @{
                            inputs            = @(@{
                                    name  = 'id'
                                    value = 'resource-id'
                                }, @{
                                    name  = 'Version'
                                    value = '1.0'
                                })
                            type              = 'Extension/AppInsightsExtension/PartType/AspNetOverviewPinnedPart'
                            asset             = @{
                                idInputName = 'id'
                                type        = 'ApplicationInsights'
                            }
                            defaultMenuItemId = 'overview'
                        }      
                    };
                    Expected = [PSCustomObject][ordered]@{
                        _ResourceId = $DashboardResourceId
                        PSTypeName  = "Dashboards"
                        type        = 'microsoft.portal/dashboards'
                        name        = 'name1'
                        apiVersion  = 'Version 1.0'
                        location    = 'test-location'
                        metadata    = @{ }
                        properties  = [PSCustomObject]@{ 
                            lenses = [PSCustomObject]@{
                                0 = [PSCustomObject]@{ 
                                    order = 0
                                    parts = [PSCustomObject]@{ 
                                        0 = [PSCustomObject][ordered]@{
                                            PSTypeName = "DashboardPart"
                                            position   = @{ }
                                            metadata   = @{
                                                inputs   = @()
                                                type     = 'Extension/HubsExtension/PartType/MarkdownPart'
                                                settings = @{
                                                    content = @{
                                                        settings = @{
                                                            content  = ''
                                                            title    = 'Test part'
                                                            subtitle = ''
                                                        }
                                                    }      
                                                }
                                            }      
                                        }
                                        1 = [PSCustomObject][ordered]@{
                                            PSTypeName = "DashboardPart"
                                            position   = @{ }
                                            metadata   = @{
                                                inputs            = @(@{
                                                        name  = 'id'
                                                        value = 'resource-id'
                                                    }, @{
                                                        name  = 'Version'
                                                        value = '1.0'
                                                    })
                                                type              = 'Extension/AppInsightsExtension/PartType/AspNetOverviewPinnedPart'
                                                asset             = @{
                                                    idInputName = 'id'
                                                    type        = 'ApplicationInsights'
                                                }
                                                defaultMenuItemId = 'overview'
                                            }      
                                        }
                                    }
                                }
                            }
                        }
                        resources   = @()
                        dependsOn   = @()
                    }
                }
            ) {
                param($Dashboard, $Part, $Expected)

                $actual = Add-ArmDashboardsPartsElement -Dashboards $Dashboard -Part $Part
                ($actual | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }) `
                | Should -Be ($Expected | ConvertTo-Json -Depth $Depth -Compress | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) })
            }
        }
    }
}
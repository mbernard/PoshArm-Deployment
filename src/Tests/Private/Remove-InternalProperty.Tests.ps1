$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
    Describe "Remove-InternalProperty" {
        It "Given <InputObject>, it returns <Expected>" -TestCases @(
            @{ InputObject = [PSCustomObject]@{
                    Name = "myName"
                    _Id  = 0
                }; Expected= [PSCustomObject]@{
                    Name = "myName"
                };
            }
            @{InputObject = [PSCustomObject]@{
                    Name = "myName"
                    _innerObect = [PSCustomObject]@{
                        innerName = "innerName"
                    }
                    _Id  = 0
                }; Expected= [PSCustomObject]@{
                    Name = "myName"
                };
            }
            @{
                InputObject = [PSCustomObject]@{
                    Name = "myName"
                    InnerObject = [PSCustomObject]@{
                        _innerName = "innerName"
                    }
                    _Id  = 0
                }; Expected= [PSCustomObject]@{
                    Name = "myName"
                    InnerObject = [PSCustomObject]@{}
                };
            }
            @{
                InputObject = [PSCustomObject]@{
                    InnerObject = @([PSCustomObject]@{
                        _innerName = "innerName"
                    })
                }; Expected= [PSCustomObject]@{
                    InnerObject = @([PSCustomObject]@{})
                };
            }
        ) {
            param($InputObject, $Expected)

            $actual = $InputObject | Remove-InternalProperty

            ($actual | ConvertTo-Json -Compress) | Should -Be ($Expected | ConvertTo-Json -Compress)
        }
    }
}
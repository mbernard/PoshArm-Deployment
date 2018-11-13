Import-Module "../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
    Describe "Remove-InternalProperty" {
        It "Given an object with internal properties, it returns the object without the internal properties" -TestCases @(
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
        ) {
            param($InputObject, $Expected)
        
            $actual = $InputObject | Remove-InternalProperty

            ($actual | ConvertTo-Json -Compress) | Should -Be ($Expected | ConvertTo-Json -Compress)
        }
    }
}
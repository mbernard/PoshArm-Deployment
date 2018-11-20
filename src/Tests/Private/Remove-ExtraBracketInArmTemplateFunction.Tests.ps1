$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
    Describe "Remove-ExtraBracketInArmTemplateFunction" {
        It "Given <InputObject> when removing extra [] then <Expected>" -TestCases @(
            @{ InputObject = [PSCustomObject]@{
                    NotAnArmTemplateFunction = "value"
                }; Expected= [PSCustomObject]@{
                    NotAnArmTemplateFunction = "value"
                };
            }
            @{ InputObject = [PSCustomObject]@{
                    ArmTemplateFunction = "[value]"
                }; Expected= [PSCustomObject]@{
                    ArmTemplateFunction = "[value]"
                };
            }
            @{ InputObject = [PSCustomObject]@{
                    ArmTemplateFunction = "[concat(value, [anotherFunction()])]"
                }; Expected = [PSCustomObject]@{
                    ArmTemplateFunction = "[concat(value, anotherFunction())]"
                };
            }
            @{InputObject = [PSCustomObject]@{
                    innerObect = [PSCustomObject]@{
                        ArmTemplateFunction = "[concat(value, [anotherFunction()])]"
                    }
                }; Expected = [PSCustomObject]@{
                    innerObect = [PSCustomObject]@{
                        ArmTemplateFunction = "[concat(value, anotherFunction())]"
                    }
                };
            }
            @{ InputObject = [PSCustomObject]@{
                    arrayProp = @(
                        @{
                            ArmTemplateFunction = "[concat(value, [anotherFunction()])]"
                        })
                }; Expected = [PSCustomObject]@{
                    arrayProp = @(
                        @{
                            ArmTemplateFunction = "[concat(value, anotherFunction())]"
                        })
                    }
            }
            @{ InputObject = [PSCustomObject]@{
                arrayProp = @(
                    "[concat(value, [anotherFunction()])]"
                   )
            }; Expected = [PSCustomObject]@{
                arrayProp = @(
                    "[concat(value, anotherFunction())]")
                }
        }
        ) {
            param($InputObject, $Expected)

            $actual = $InputObject | Remove-ExtraBracketInArmTemplateFunction

            ($actual | ConvertTo-Json -Compress) | Should -Be ($Expected | ConvertTo-Json -Compress)
        }
    }
}
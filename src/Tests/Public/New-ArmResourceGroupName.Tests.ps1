$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../PoshArmDeployment" -Force

Describe "New-ArmResourceGroupName" {

    It "Given a set of configuration values ('<ProjectName>', '<EnvironmentCode>', '<Context>', '<Location>'), it returns '<Expected>'" -TestCases @(
        @{ ProjectName = "pn1"; Environmentcode = "ec2"; Context = "c3"; Location = "l4"; Expected = "pn1-ec2-c3-l4" ; }
        @{ ProjectName = "PN1"; Environmentcode = "EC2"; Context = "C3"; Location = "L4"; Expected = "pn1-ec2-c3-l4" ; }
        @{ ProjectName = ""; Environmentcode = "ec2"; Context = "c3"; Location = "l4"; Expected = "-ec2-c3-l4" ; }
        @{ ProjectName = ""; Environmentcode = ""; Context = ""; Location = ""; Expected = "-" ; }
    ) {
        param($ProjectName, $EnvironmentCode, $Context, $Location, $Expected)

        $name = New-ArmResourceGroupName -ProjectName $ProjectName -EnvironmentCode $EnvironmentCode -Context $Context -Location $Location
        $name | Should Be $Expected
    }

    It "Given a custom naming convention '<NamingConvention>' then name is equal to '<Expected>'" -TestCases @(
        @{ NamingConvention = "myNewNamingConvention"; Expected = "myNewNamingConvention" }
        @{ NamingConvention = "my{delimiter}New*{projectname}*NamingConvention"; Expected = "my-New*pn*NamingConvention" }
        @{ NamingConvention = "my{delimiter}New*{EnvironmentCode}*NamingConvention"; Expected = "my-New*ec*NamingConvention" }
        @{ NamingConvention = "my{delimiter}New*{Context}*NamingConvention"; Expected = "my-New*c*NamingConvention" }
        @{ NamingConvention = "my{delimiter}New*{Location}*NamingConvention"; Expected = "my-New*l*NamingConvention" }
    ) {
        param($NamingConvention, $Expected)
        $name = New-ArmResourceGroupName -NamingConvention $NamingConvention -ProjectName "pn" -EnvironmentCode "ec" -Context "c" -Location "l"
        $name | Should Be $Expected
    }

    It "Given a delimiter '<Delimiter>' then name is equal to '<Expected>'" -TestCases @(
        @{ Delimiter = "*"; Expected = "*"}
        @{ Delimiter = "a"; Expected = "a"}
        @{ Delimiter = "abc"; Expected = "abc"}
    ){
        param($Delimiter, $Expected)
        $name = New-ArmResourceGroupName -Delimiter $Delimiter
        $name | Should Be $Expected
    }

    It "Given a globally set naming convention '<NamingConvention>' then name is equal to '<Expected>'" -TestCases @(
        @{ NamingConvention = "myNewNamingConvention"; Expected = "myNewNamingConvention" }
        @{ NamingConvention = "my{delimiter}New*{projectname}*NamingConvention"; Expected = "my-New*pn*NamingConvention" }
        @{ NamingConvention = "my{delimiter}New*{EnvironmentCode}*NamingConvention"; Expected = "my-New*ec*NamingConvention" }
        @{ NamingConvention = "my{delimiter}New*{Context}*NamingConvention"; Expected = "my-New*c*NamingConvention" }
        @{ NamingConvention = "my{delimiter}New*{Location}*NamingConvention"; Expected = "my-New*l*NamingConvention" }
    ) {
        param($NamingConvention, $Expected)

        Set-ArmResourceGroupNamingConvention $NamingConvention
        $name = New-ArmResourceGroupName -ProjectName "pn" -EnvironmentCode "ec" -Context "c" -Location "l"
        $name | Should Be $Expected
    }
}
$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../PoshArmDeployment" -Force

Describe "New-ArmResourceName" {
    It "Given a '<Name>', it returns '<Expected>'" -TestCases @(
        @{ Name = "name1"; Expected = "[concat('name10', uniqueString(name1))]" }
    ){
        param($Name, $Expected)

        $name = New-ArmResourceName -ResourceName $Name -ResourceType "Microsoft.Storage/storageAccounts"
        $name | Should -Be $Expected
    }
}
$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../PoshArmDeployment" -Force

Describe "New-ArmResourceName" {
    It "Given a '<Name>', it returns '<Expected>'" -TestCases @(
        @{ Name = "name1"; ResourceType = "Microsoft.Storage/storageAccounts"; Expected = "[concat('name10', uniqueString('sa','name1'))]" }
        @{ Name = "name1"; ResourceType = "Microsoft.KeyVault/vaults"; Expected = "[concat('name1-', uniqueString('kv','name1'))]" }
    ){
        param($Name, $ResourceType, $Expected)

        $name = New-ArmResourceName -ResourceName $Name -ResourceType $ResourceType
        $name | Should Be $Expected
    }

    It "Given no name, then resource type is used" -TestCases @(
        @{ ResourceType = "Microsoft.Storage/storageAccounts"; Expected = "[concat('sa0', uniqueString('sa','sa'))]" }
        @{ ResourceType = "Microsoft.KeyVault/vaults"; Expected = "[concat('kv-', uniqueString('kv','kv'))]" }
    ){
        param($ResourceType, $Expected)

        $name = New-ArmResourceName -ResourceType $ResourceType
        $name | Should Be $Expected
    }
}
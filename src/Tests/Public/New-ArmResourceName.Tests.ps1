$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../PoshArmDeployment" -Force

Describe "New-ArmResourceName" {
    It "Given a '<Name>', it returns '<Expected>'" -TestCases @(
        @{ Name = "name1"; ResourceType = "Microsoft.Storage/storageAccounts"; Expected = "[concat('name10', uniqueString('sa','name1'),'')]" }
        @{ Name = "name1"; ResourceType = "Microsoft.KeyVault/vaults"; Expected = "[concat('name1-', uniqueString('kv','name1'),'')]" }
    ){
        param($Name, $ResourceType, $Expected)

        $name = New-ArmResourceName -ResourceName $Name -ResourceType $ResourceType
        $name | Should Be $Expected
    }

    It "Given no name, then resource type is used" -TestCases @(
        @{ ResourceType = "Microsoft.Storage/storageAccounts"; Expected = "[concat('sa0', uniqueString('sa','sa'),'')]" }
        @{ ResourceType = "Microsoft.KeyVault/vaults"; Expected = "[concat('kv-', uniqueString('kv','kv'),'')]" }
    ){
        param($ResourceType, $Expected)

        $name = New-ArmResourceName -ResourceType $ResourceType
        $name | Should Be $Expected
    }

    It "Given custom naming convention" -TestCases @(
        @{ NamingConvention = "something{resourcename}aa{delimiter}{hash}" ; ResourceType = "Microsoft.Storage/storageAccounts"; Expected = "[concat('somethingsaaa0', uniqueString('sa','sa'),'')]" }
        @{ NamingConvention = "something{resourcename}aa{delimiter}{hash}"; ResourceType = "Microsoft.KeyVault/vaults"; Expected = "[concat('somethingkvaa-', uniqueString('kv','kv'),'')]" }
        @{ NamingConvention = "a{hash}{resourcename}{delimiter}"; ResourceType = "Microsoft.KeyVault/vaults"; Expected = "[concat('a', uniqueString('kv','kv'),'kv-')]" }
    ){
        param($NamingConvention, $ResourceType, $Expected)

        $name = New-ArmResourceName -ResourceType $ResourceType -NamingConvention $NamingConvention
        $name | Should Be $Expected
    }

    It "Given a globally set naming convention '<NamingConvention>' then name is equal to '<Expected>'" -TestCases @(
        @{ NamingConvention = "something{resourcename}aa{delimiter}{hash}" ; ResourceType = "Microsoft.Storage/storageAccounts"; Expected = "[concat('somethingsaaa0', uniqueString('sa','sa'),'')]" }
        @{ NamingConvention = "something{resourcename}aa{delimiter}{hash}"; ResourceType = "Microsoft.KeyVault/vaults"; Expected = "[concat('somethingkvaa-', uniqueString('kv','kv'),'')]" }
        @{ NamingConvention = "a{hash}{resourcename}{delimiter}"; ResourceType = "Microsoft.KeyVault/vaults"; Expected = "[concat('a', uniqueString('kv','kv'),'kv-')]" }
    ) {
        param($NamingConvention, $ResourceType, $Expected)

        Set-ArmResourceNamingConvention $NamingConvention
        $name = New-ArmResourceName -ResourceType $ResourceType
        $name | Should Be $Expected
    }
}
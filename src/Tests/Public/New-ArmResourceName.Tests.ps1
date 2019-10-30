$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../PoshArmDeployment" -Force

Describe "New-ArmResourceName" {

    Set-EnvironmentCode "Prod"

    It "Given a '<Name>', it returns '<Expected>'" -TestCases @(
        @{ Name = "name1"; ResourceType = "Microsoft.Storage/storageAccounts"; Expected = "[concat('prod0name10', uniqueString('prod','sa','name1'),'')]" }
        @{ Name = "name1"; ResourceType = "Microsoft.KeyVault/vaults"; Expected = "[concat('prod-name1-', uniqueString('prod','kv','name1'),'')]" }
    ){
        param($Name, $EnvironmentCode, $ResourceType, $Expected)

        $name = New-ArmResourceName -ResourceName $Name -ResourceType $ResourceType
        $name | Should Be $Expected
    }

    It "Given no name, then resource type is used" -TestCases @(
        @{ ResourceType = "Microsoft.Storage/storageAccounts"; Expected = "[concat('prod0sa0', uniqueString('prod','sa','sa'),'')]" }
        @{ ResourceType = "Microsoft.KeyVault/vaults"; Expected = "[concat('prod-kv-', uniqueString('prod','kv','kv'),'')]" }
    ){
        param($ResourceType, $Expected)

        $name = New-ArmResourceName -ResourceType $ResourceType
        $name | Should Be $Expected
    }

    It "Given custom naming convention" -TestCases @(
        @{ NamingConvention = "something{resourcename}aa{delimiter}{hash}" ; ResourceType = "Microsoft.Storage/storageAccounts"; Expected = "[concat('somethingsaaa0', uniqueString('prod','sa','sa'),'')]" }
        @{ NamingConvention = "something{resourcename}aa{delimiter}{hash}"; ResourceType = "Microsoft.KeyVault/vaults"; Expected = "[concat('somethingkvaa-', uniqueString('prod','kv','kv'),'')]" }
        @{ NamingConvention = "a{hash}{resourcename}{delimiter}"; ResourceType = "Microsoft.KeyVault/vaults"; Expected = "[concat('a', uniqueString('prod','kv','kv'),'kv-')]" }
    ){
        param($NamingConvention, $ResourceType, $Expected)

        $name = New-ArmResourceName -ResourceType $ResourceType -NamingConvention $NamingConvention
        $name | Should Be $Expected
    }

    It "Given a globally set naming convention '<NamingConvention>' then name is equal to '<Expected>'" -TestCases @(
        @{ NamingConvention = "something{resourcename}aa{delimiter}{hash}" ; ResourceType = "Microsoft.Storage/storageAccounts"; Expected = "[concat('somethingsaaa0', uniqueString('prod','sa','sa'),'')]" }
        @{ NamingConvention = "something{resourcename}aa{delimiter}{hash}"; ResourceType = "Microsoft.KeyVault/vaults"; Expected = "[concat('somethingkvaa-', uniqueString('prod','kv','kv'),'')]" }
        @{ NamingConvention = "a{hash}{resourcename}{delimiter}"; ResourceType = "Microsoft.KeyVault/vaults"; Expected = "[concat('a', uniqueString('prod','kv','kv'),'kv-')]" }
    ) {
        param($NamingConvention, $ResourceType, $Expected)

        Set-ArmResourceNamingConvention $NamingConvention
        $name = New-ArmResourceName -ResourceType $ResourceType
        $name | Should Be $Expected
    }
}
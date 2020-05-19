$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
    Describe "New-ArmServiceBusResource" {
        Context "Integration tests" {
            It "Simple Sample" -Test {
                Invoke-IntegrationTest -ArmResourcesScriptBlock `
                {
                    New-ArmResourceName Microsoft.ServiceBus/namespaces `
                    | New-ArmServiceBusResource `
                    | Add-ArmResource
                }
            }

            It "Sample with forwards" -Test {
                Invoke-IntegrationTest -ArmResourcesScriptBlock `
                {
                    $ServiceBus = New-ArmResourceName Microsoft.ServiceBus/namespaces `
                    | New-ArmServiceBusResource `
                    | Add-ArmResource -PassThru

                    $ServiceBus.name | New-ArmServiceBusQueueResource -Name "testQueue"  `
                    | Add-ArmDependencyOn -Dependency $ServiceBus -PassThru  `
                    | Add-ArmResource

                    $Topic = $ServiceBus.name | New-ArmServiceBusTopicResource -Name "testTopic"  `
                    | Add-ArmDependencyOn -Dependency $ServiceBus -PassThru  `
                    | Add-ArmResource -PassThru

                    $Topic | New-ArmServiceBusTopicSubscriptionResource -Name "testTopic" -Forward "testQueue"  `
                    | Add-ArmDependencyOn -Dependency $Topic -PassThru  `
                    | Add-ArmResource
                }
            }
        }
    }
}
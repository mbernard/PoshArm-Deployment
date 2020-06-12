$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../../../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
    Context "Integration tests" {
        It "Default" -Test {
            Invoke-IntegrationTest -ArmResourcesScriptBlock `
            {
                $Subnet = New-ArmVirtualNetworkSubnet -Name "general" -AddressPrefix "172.168.1.0/24"

                New-ArmResourceName Microsoft.Network/virtualNetworks `
                | New-ArmVirtualNetworkResource -AddressSpace "172.168.0.0/16" `
                | Add-ArmVirtualNetworkSubnet -Subnet $Subnet `
                | Add-ArmResource

                New-ArmResourceName Microsoft.Network/loadBalancers -ResourceName "internal" `
                | New-ArmLoadBalancerResource -Sku "Basic" `
                | Add-ArmLoadBalancerBackendAddressPool `
                | Add-ArmInternalLoadBalancerFrontEndIpConfiguration -IP "172.168.1.101" -Subnet $Subnet `
                | Add-ArmResource
            }
        }
    }
}


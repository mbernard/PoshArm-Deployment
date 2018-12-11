function Add-ArmNic {
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param(
        [PSTypeName("VirtualMachineScaleSet")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $VirtualMachineScaleSet,
        [PSTypeName("Subnet")]
        [Parameter(Mandatory)]
        $Subnet,
        [string]
        $Name = "default",
        [Switch]
        $IsPrimary
    )

    If ($PSCmdlet.ShouldProcess("Adding network interface configuration to a virtual machine scale set")) {
        $Nic = [PSCustomObject][ordered]@{
            PSTypeName = "Nic"
            name       = $Name
            properties = @{
                enableIPForwarding = $false
                primary          = $IsPrimary.ToBool()
                ipConfigurations = @(
                    @{
                        name       = $Name
                        properties = @{
                            subnet                                = @{
                                id = $Subnet._ResourceId
                            }
                            loadBalancerBackendAddressPools       = @()
                            loadBalancerInboundNatPools           = @()
                            applicationGatewayBackendAddressPools = @()
                        }
                    }
                )
            }
            _Subnet    = $Subnet
        }

        $VirtualMachineScaleSet.properties.virtualMachineProfile.networkProfile.networkInterfaceConfigurations += $Nic
        return $VirtualMachineScaleSet
    }
}
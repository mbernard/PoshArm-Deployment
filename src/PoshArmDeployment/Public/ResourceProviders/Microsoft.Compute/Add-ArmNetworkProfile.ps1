function Add-ArmNetworkProfile {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = "vm")]
    Param(
        [PSTypeName("VirtualMachine")]
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "vm")]
        $VirtualMachine,
        [PSTypeName("VirtualMachineScaleSet")]
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "vmss")]
        $VirtualMachineScaleSet,
        [PSTypeName("Subnet")]
        [Parameter(Mandatory)]
        $Subnet,
        [string]
        $Name = "NIC-default"
    )

    Process {
        If ($PSCmdlet.ShouldProcess("Adding network profile to a virtual machine")) {
            $NetworkProfile = @{
                networkInterfaceConfigurations = @(
                    @{
                        name       = $Name
                        properties = @{
                            primary          = $true
                            ipConfigurations = @(
                                @{
                                    name                                  = $Name
                                    properties                            = @{
                                        subnet = @{
                                            id = $Subnet._ResourceId
                                        }
                                    }
                                }
                            )
                        }
                    }
                )
            }

            if ($PSCmdlet.ParameterSetName -eq "vm") {
                $VirtualMachine.properties.networkProfile = $NetworkProfile
                $VirtualMachine.dependsOn += $Subnet._VirtualNetwork._ResourceId
                return $VirtualMachine
            }
            else {
                $VirtualMachineScaleSet.properties.virtualMachineProfile.networkProfile = $NetworkProfile
                $VirtualMachineScaleSet.dependsOn += $Subnet._VirtualNetwork._ResourceId
                return $VirtualMachineScaleSet
            }
        }
    }
}
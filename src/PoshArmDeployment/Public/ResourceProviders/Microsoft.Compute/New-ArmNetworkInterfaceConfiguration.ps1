function New-ArmNetworkInterfaceConfiguration {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("NetworkInterfaceConfiguration")]
    Param(
        [PSTypeName("Subnet")]
        [Parameter(Mandatory)]
        $Subnet,
        [string]
        $Name = "default",
        [Switch]
        $IsPrimary
    )

    Process {
        If ($PSCmdlet.ShouldProcess("Create a network interface configuration")) {
            $NetworkInterfaceConfiguration = [PSCustomObject][ordered]@{
                PSTypeName= "NetworkInterfaceConfiguration"
                name       = $Name
                properties = @{
                    primary          = $IsPrimary.ToBool()
                    ipConfigurations = @(
                        @{
                            name       = $Name
                            properties = @{
                                subnet                          = @{
                                    id = $Subnet._ResourceId
                                }
                                loadBalancerBackendAddressPools = @()
                                applicationGatewayBackendAddressPools = @()
                            }
                        }
                    )
                }
                _Subnet = $Subnet
            }

            return $NetworkInterfaceConfiguration
        }
    }
}
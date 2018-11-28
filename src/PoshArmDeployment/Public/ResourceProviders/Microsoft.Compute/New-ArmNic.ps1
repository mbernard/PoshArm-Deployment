function New-ArmNic {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("Nic")]
    Param(
        [PSTypeName("Subnet")]
        [Parameter(Mandatory)]
        $Subnet,
        [string]
        $Name = "default",
        [Switch]
        $IsPrimary
    )

    If ($PSCmdlet.ShouldProcess("Create a network interface configuration")) {
        $Nic = [PSCustomObject][ordered]@{
            PSTypeName = "Nic"
            name       = $Name
            properties = @{
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

        return $Nic
    }
}
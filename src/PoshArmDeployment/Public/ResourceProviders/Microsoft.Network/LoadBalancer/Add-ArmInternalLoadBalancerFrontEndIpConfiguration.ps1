function Add-ArmInternalLoadBalancerFrontendIpConfiguration {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("LoadBalancer")]
    Param(
        [PSTypeName("LoadBalancer")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $LoadBalancer,
        [Parameter(Mandatory)]
        [PSTypeName("Subnet")]
        $Subnet,
        [Parameter(Mandatory)]
        [string]
        $IP,
        [string]
        $Name = "default"
    )

    If ($PSCmdlet.ShouldProcess("Adding front end ip configuration")) {
        $FrontEndIpconfiguration = [PSCustomObject][Ordered]@{
            name       = $Name
            properties = @{
                subnet = @{
                    id = $Subnet._ResourceId
                }
                privateIPAllocationMethod = "Static"
                privateIPAddress = $IP
            }
        }
        $LoadBalancer.properties.frontEndIpconfigurations += $FrontEndIpconfiguration
        return $LoadBalancer | Add-ArmDependencyOn -Dependency $Subnet._VirtualNetwork -PassThru
    }
}
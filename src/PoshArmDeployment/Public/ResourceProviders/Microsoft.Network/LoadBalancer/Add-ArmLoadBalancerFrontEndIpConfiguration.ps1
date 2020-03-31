function Add-ArmLoadBalancerFrontendIpConfiguration {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("LoadBalancer")]
    Param(
        [PSTypeName("LoadBalancer")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $LoadBalancer,
        [Parameter(Mandatory)]
        [PSTypeName("PublicIp")]
        $PublicIp,
        [string]
        $Name = "default"
    )

    If ($PSCmdlet.ShouldProcess("Adding front end ip configuration")) {
        $FrontEndIpconfiguration = [PSCustomObject][Ordered]@{
            name       = $Name
            properties = @{
                publicIPAddress = @{
                    id = $PublicIp._ResourceId
                }
            }
        }
        $LoadBalancer._Ip = $PublicIp
        $LoadBalancer.properties.frontEndIpconfigurations += $FrontEndIpconfiguration
        return $LoadBalancer | Add-ArmDependencyOn -Dependency $PublicIp -PassThru
    }
}
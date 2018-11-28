function New-ArmLoadBalancerFrontEndIpConfiguration {
    [CmdletBinding(SupportsShouldProcess = $True)]
    [OutputType("LoadBalancerFrontEndIpConfiguration")]
    Param(
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name = "default",
        [Parameter(Mandatory, ValueFromPipeline)]
        [PSTypeName("PublicIp")]
        $PublicIp
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm load balancer front end ip configuration")) {
        return [PSCustomObject][Ordered]@{
            _PublicIp = $PublicIp
            _ResourceId = "Not added to a load balancer yet"
            PSTypeName = "LoadBalancerFrontEndIpConfiguration"
            name       = $Name
            properties = @{
                publicIPAddress = @{
                    id = $PublicIp._ResourceId
                }
            }
        }
    }
}


function Add-ArmApplicationGatewayFrontendIpConfiguration {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationGateway")]
    Param(
        [PSTypeName("ApplicationGateway")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $ApplicationGateway,
        [Parameter(Mandatory)]
        [PSTypeName("PublicIp")]
        $PublicIp,
        [string]
        $Name = "default"
    )

    If ($PSCmdlet.ShouldProcess("Adding front end ip configuration")) {
        $FrontEndIpconfiguration = [PSCustomObject][Ordered]@{
            _PublicIp  = $PublicIp
            name       = $Name
            properties = @{
                publicIPAddress = @{
                    id = $PublicIp._ResourceId
                }
            }
        }

        $ApplicationGateway.properties.frontendIPConfigurations += $FrontEndIpconfiguration
        return $ApplicationGateway | Add-ArmDependencyOn -Dependency $PublicIp -PassThru
    }
}
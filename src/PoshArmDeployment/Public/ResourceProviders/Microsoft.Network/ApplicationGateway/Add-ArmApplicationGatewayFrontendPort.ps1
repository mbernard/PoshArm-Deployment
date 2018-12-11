function Add-ArmApplicationGatewayFrontendPort {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationGateway")]
    Param(
        [PSTypeName("ApplicationGateway")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $ApplicationGateway,
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name = "default",
        [int]
        $Port = 443
    )

    If ($PSCmdlet.ShouldProcess("Adding frontend port")) {
        $FrontEndPort = [PSCustomObject][ordered]@{
            type       = 'Microsoft.Network/applicationGateways/frontendPorts'
            name       = $Name
            properties = @{
                port = $Port
            }
        }

        $ApplicationGateway.properties.frontendPorts += $FrontendPort

        return $ApplicationGateway
    }
}
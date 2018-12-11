function Add-ArmApplicationGatewayHttpListener {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationGateway")]
    Param(
        [PSTypeName("ApplicationGateway")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $ApplicationGateway,
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name = "default",
        [string]
        $FrontendIPConfigurationName,
        [string]
        $FrontendPortName,
        [string]
        $SslCertificateName,
        [String]
        [ValidateSet("Http", "Https")]
        $Protocol = "Https"
    )

    if (!$FrontendIPConfigurationName) {
        $FrontendIPConfigurationName = $ApplicationGateway.properties.frontendIPConfigurations[0].Name
    }

    if (!$FrontendPortName) {
        $FrontendPortName = $ApplicationGateway.properties.frontendPorts[0].Name
    }

    if (!$SslCertificateName -And $Protocol -eq "Https") {
        $SslCertificateName = $ApplicationGateway.properties.sslCertificates[0].Name
    }

    If ($PSCmdlet.ShouldProcess("Adding http listener")) {
        $ApplicationGatewayResourceId = $ApplicationGateway._ResourceId

        $Properties = [PSCustomObject]@{
            frontendIPConfiguration     = @{
                id = "[concat($ApplicationGatewayResourceId, '/frontendIPConfigurations/', '$FrontEndIpConfigurationName')]"
            }
            frontendPort                = @{
                id = "[concat($ApplicationGatewayResourceId, '/frontendPorts/', '$FrontendPortName')]"
            }
            protocol                    = $Protocol
            requireServerNameIndication = $false
        }

        if ($Protocol -eq "Https") {
            $SslCert = @{
                id = "[concat($ApplicationGatewayResourceId, '/sslCertificates/', '$SslCertificateName')]"
            }
            $Properties | Add-Member -MemberType NoteProperty -Name "sslCertificate" -Value $SslCert
        }

        $HttpListener = [PSCustomObject][ordered]@{
            type       = 'Microsoft.Network/applicationGateways/httpListeners'
            name       = $Name
            properties = $Properties
        }

        $ApplicationGateway.properties.httpListeners += $HttpListener

        return $ApplicationGateway
    }
}
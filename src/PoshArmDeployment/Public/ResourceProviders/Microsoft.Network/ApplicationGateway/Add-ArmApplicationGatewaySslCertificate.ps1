function Add-ArmApplicationGatewaySslCertificate {
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
        [Parameter(Mandatory)]
        $Data,
        [string]
        [Parameter(Mandatory)]
        $Password
    )

    If ($PSCmdlet.ShouldProcess("Adding SSL certificate")) {
        $SslCertificate = [PSCustomObject][ordered]@{
            name        = $Name
            properties  = @{
                data     = $Data
                password = $Password
            }
            type        = "Microsoft.Network/applicationGateways/sslCertificates"
        }

        $ApplicationGateway.properties.SslCertificates += $SslCertificate

        return $ApplicationGateway
    }
}
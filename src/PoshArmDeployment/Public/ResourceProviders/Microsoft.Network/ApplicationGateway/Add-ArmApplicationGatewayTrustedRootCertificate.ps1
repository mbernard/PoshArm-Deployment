function Add-ArmApplicationGatewayTrustedRootCertificate {
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
        $KeyvaultSecretId
    )

    If ($PSCmdlet.ShouldProcess("Adding SSL certificate")) {
        $TrustedRootCertificate = [PSCustomObject][ordered]@{
            name        = $Name
            properties  = @{
                keyvaultSecretId = $KeyvaultSecretId
            }
        }

        $ApplicationGateway.properties.trustedRootCertificates += $TrustedRootCertificate

        return $ApplicationGateway
    }
}
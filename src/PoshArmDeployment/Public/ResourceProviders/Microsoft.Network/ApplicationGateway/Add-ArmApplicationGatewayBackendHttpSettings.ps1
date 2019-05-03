function Add-ArmApplicationGatewayBackendHttpSettings {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationGateway")]
    Param(
        [PSTypeName("ApplicationGateway")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $ApplicationGateway,
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name = "default",
        [Parameter(Mandatory)]
        [int]
        $Port = 443,
        [ValidateSet("Http", "Https")]
        [string]
        $Protocol = "Https",
        [Switch]
        $CookieBasedAffinity,
        [Switch]
        $PickHostNameFromBackendAddress,
        [string]
        $Path,
        [int]
        $RequestTimeoutInSec = 30,
        [string]
        $TrustedRootCertificateName,
        [PSCustomObject]
        $Probe
    )

    if (!$TrustedRootCertificateName) {
        $TrustedRootCertificateName = $ApplicationGateway.properties.trustedRootCertificates[0].Name
    }

    If ($PSCmdlet.ShouldProcess("Adding backend http settings")) {
        $ApplicationGatewayResourceId = $ApplicationGateway._ResourceId

        $BackendHttpSettings = [PSCustomObject][ordered]@{
            type       = 'Microsoft.Network/applicationGateways/backendHttpSettingsCollection'
            name       = $Name
            properties = @{
                port                           = $Port
                protocol                       = $Protocol
                cookieBasedAffinity            = if ($CookieBasedAffinity) { "Enabled" } else { "Disabled" }
                pickHostNameFromBackendAddress = $PickHostNameFromBackendAddress.ToBool()
                path                           = $Path
                requestTimeout                 = $RequestTimeoutInSec
                trustedRootCertificates        = @()
                probe                          = $Probe
            }
        }

        if ($Protocol -eq "Https") {
            $BackendHttpSettings.properties.trustedRootCertificates += @{
                id = "[concat($ApplicationGatewayResourceId, '/trustedRootCertificates/', '$TrustedRootCertificateName')]"
            }
        }

        $ApplicationGateway.properties.backendHttpSettingsCollection += $BackendHttpSettings

        return $ApplicationGateway
    }
}
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
        $RequestTimeoutInSec = 30
    )

    If ($PSCmdlet.ShouldProcess("Adding backend http settings")) {
        $BackendHttpSettings =  [PSCustomObject][ordered]@{
            type        = 'Microsoft.Network/applicationGateways/backendHttpSettingsCollection'
            name        = $Name
            properties  = @{
                port                           = $Port
                protocol                       = $Protocol
                cookieBasedAffinity            = if ($CookieBasedAffinity) { "Enabled"} else {"Disabled"}
                pickHostNameFromBackendAddress = $PickHostNameFromBackendAddress.ToBool()
                path                           = $Path
                requestTimeout                 = $RequestTimeoutInSec
            }
        }
        # $BackendHttpSettings._ResourceId = "[concat($ApplicationGatewayResourceId, '/backendHttpSettingsCollection/', '$BackendHttpSettingsName')]"

        $ApplicationGateway.properties.backendHttpSettingsCollection += $BackendHttpSettings

        return $ApplicationGateway
    }
}
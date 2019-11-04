function Add-ArmApplicationGatewayUrlMap {
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
        $BackendAddressPoolName,
        [string]
        $BackendHttpSettingsName
    )

    If ($PSCmdlet.ShouldProcess("Creating new Url map")) {
        if (!$BackendAddressPoolName) {
            $BackendAddressPoolName = $ApplicationGateway.properties.backendAddressPools[0].Name
        }
        if (!$BackendHttpSettingsName) {
            $BackendHttpSettingsName = $ApplicationGateway.properties.backendHttpSettingsCollection[0].Name
        }
        $ApplicationGatewayResourceId = $ApplicationGateway._ResourceId

        $UrlPathMap = [PSCustomObject][ordered]@{
            type       = 'Microsoft.Network/applicationGateways/urlPathMaps'
            name       = $Name
            properties = @{
                defaultBackendAddressPool  = @{
                    id = "[concat($ApplicationGatewayResourceId, '/backendAddressPools/', '$BackendAddressPoolName')]"
                }
                defaultBackendHttpSettings = @{
                    id = "[concat($ApplicationGatewayResourceId, '/backendHttpSettingsCollection/', '$BackendHttpSettingsName')]"
                }
                pathRules                  = @()
            }
        }

        $ApplicationGateway.properties.urlPathMaps += $UrlPathMap

        return $ApplicationGateway
    }
}
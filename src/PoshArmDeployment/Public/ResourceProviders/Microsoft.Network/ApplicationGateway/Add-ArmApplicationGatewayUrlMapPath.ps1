function Add-ArmApplicationGatewayUrlMapPath {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationGateway")]
    Param(
        [PSTypeName("ApplicationGateway")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $ApplicationGateway,
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        [Parameter(Mandatory)]
        $Name,
        [Parameter(Mandatory)]
        [string[]]
        $Paths,
        [string]
        $UrlMapName = 'default',
        [string]
        $BackendAddressPoolName,
        [string]
        $BackendHttpSettingsName
    )

    If ($PSCmdlet.ShouldProcess("Adding new Url path to map")) {
        if (!$BackendAddressPoolName) {
            $BackendAddressPoolName = $ApplicationGateway.properties.backendAddressPools[0].Name
        }
        if (!$BackendHttpSettingsName) {
            $BackendHttpSettingsName = $ApplicationGateway.properties.backendHttpSettingsCollection[0].Name
        }
        $ApplicationGatewayResourceId = $ApplicationGateway._ResourceId

        $PathRule = @{
            name       = $Name
            properties = @{
                paths               = $Paths
                backendAddressPool  = @{
                    id = "[concat($ApplicationGatewayResourceId, '/backendAddressPools/', '$($BackendAddressPoolName)')]"
                }
                backendHttpSettings = @{
                    id = "[concat($ApplicationGatewayResourceId, '/backendHttpSettingsCollection/', '$($BackendHttpSettingsName)')]"
                }
            }
        }

        $Map = $ApplicationGateway.properties.urlPathMaps | Where-Object { $_.name -Match $UrlMapName }
        $Map[0].properties.pathRules += $PathRule

        return $ApplicationGateway
    }
}
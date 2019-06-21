function Add-ArmApplicationGatewayUrlPathMap {
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
        $BackendHttpSettingsName,
        [PSCustomObject]
        $PathRulesConfigs
    )

    if (!$BackendAddressPoolName) {
        $BackendAddressPoolName = $ApplicationGateway.properties.backendAddressPools[0].Name
    }

    if (!$BackendHttpSettingsName) {
        $BackendHttpSettingsName = $ApplicationGateway.properties.backendHttpSettingsCollection[0].Name
    }
    
    $ApplicationGatewayResourceId = $ApplicationGateway._ResourceId
    
    $PathRules = @()
    foreach ($PathRuleConfig in $PathRulesConfigs) {
        $PathRules += @{
            name       = $PathRuleConfig.name
            properties = @{
                paths               = $PathRuleConfig.paths
                backendAddressPool  = @{
                    id = "[concat($ApplicationGatewayResourceId, '/backendAddressPools/', '$($PathRuleConfig.backendAddressPoolName)')]" 
                }
                backendHttpSettings = @{
                    id = "[concat($ApplicationGatewayResourceId, '/backendHttpSettingsCollection/', '$($PathRuleConfig.backendHttpSettingsName)')]" 
                }
            }
        }
    }

    If ($PSCmdlet.ShouldProcess("Adding Url path maps")) {
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
                pathRules                  = $PathRules
            }
        }

        $ApplicationGateway.properties.urlPathMaps += $UrlPathMap

        return $ApplicationGateway
    }
}
function Add-ArmApplicationGatewayRequestRoutingRule {
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
        [ValidateSet("Basic", "PathBasedRouting")]
        $RuleType = "Basic",
        [string]
        $HttpListenerName,
        [string]
        $UrlPathMapName = 'default',
        [string]
        $BackendAddressPoolName,
        [string]
        $BackendHttpSettingsName
    )

    if (!$HttpListenerName) {
        $HttpListenerName = $ApplicationGateway.properties.httpListeners[0].Name
    }

    If ($PSCmdlet.ShouldProcess("Adding backend http settings")) {
        $ApplicationGatewayResourceId = $ApplicationGateway._ResourceId

        $RequestRoutingRule = [PSCustomObject][ordered]@{
            type       = 'Microsoft.Network/applicationGateways/requestRoutingRules'
            name       = $Name
            properties = @{
                ruleType     = $RuleType
                httpListener = @{
                    id = "[concat($ApplicationGatewayResourceId, '/httpListeners/', '$HttpListenerName')]"
                }
            }
        }

        if ($RuleType -eq 'Basic') {
            if (!$BackendAddressPoolName) {
                $BackendAddressPoolName = $ApplicationGateway.properties.backendAddressPools[0].Name
            }
        
            if (!$BackendHttpSettingsName) {
                $BackendHttpSettingsName = $ApplicationGateway.properties.backendHttpSettingsCollection[0].Name
            }

            $RequestRoutingRule.Properties.backendAddressPool = @{
                id = "[concat($ApplicationGatewayResourceId, '/backendAddressPools/', '$BackendAddressPoolName')]"
            }
            $RequestRoutingRule.Properties.backendHttpSettings = @{
                id = "[concat($ApplicationGatewayResourceId, '/backendHttpSettingsCollection/', '$BackendHttpSettingsName')]"
            }
        }
        elseif ($RuleType -eq 'PathBasedRouting') {
            $RequestRoutingRule.Properties.urlPathMap = @{
                id = "[concat($ApplicationGatewayResourceId, '/urlPathMaps/', '$UrlPathMapName')]"
            }
        }
    }

    $ApplicationGateway.properties.requestRoutingRules += $RequestRoutingRule
    
    return $ApplicationGateway
}
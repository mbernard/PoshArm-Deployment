function Add-ArmApplicationGatewayBasicRequestRoutingRule {
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
        $HttpListenerName,
        [string]
        $BackendAddressPoolName,
        [string]
        $BackendHttpSettingsName
    )

    $RuleType = 'basic'

    if (!$HttpListenerName) {
        $HttpListenerName = $ApplicationGateway.properties.httpListeners[0].Name
    }

    If ($PSCmdlet.ShouldProcess("Adding basic routing rule")) {
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

    $ApplicationGateway.properties.requestRoutingRules += $RequestRoutingRule
    
    return $ApplicationGateway
}
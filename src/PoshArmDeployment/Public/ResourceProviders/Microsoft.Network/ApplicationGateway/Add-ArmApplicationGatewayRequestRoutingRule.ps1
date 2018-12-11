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
        [ValidateSet("Basic")]
        $RuleType = "Basic",
        [string]
        $HttpListenerName,
        [string]
        $BackendAddressPoolName,
        [string]
        $BackendHttpSettingsName
    )

    if (!$HttpListenerName) {
        $HttpListenerName = $ApplicationGateway.properties.httpListeners[0].Name
    }

    if (!$BackendAddressPoolName) {
        $BackendAddressPoolName = $ApplicationGateway.properties.backendAddressPools[0].Name
    }

    if (!$BackendHttpSettingsName) {
        $BackendHttpSettingsName = $ApplicationGateway.properties.backendHttpSettingsCollection[0].Name
    }

    If ($PSCmdlet.ShouldProcess("Adding backend http settings")) {
        $ApplicationGatewayResourceId = $ApplicationGateway._ResourceId

        $RequestRoutingRule = [PSCustomObject][ordered]@{
            type       = 'Microsoft.Network/applicationGateways/requestRoutingRules'
            name       = $Name
            properties = @{
                ruleType            = $RuleType
                httpListener        = @{
                    id = "[concat($ApplicationGatewayResourceId, '/httpListeners/', '$HttpListenerName')]"
                }
                backendAddressPool  = @{
                    id = "[concat($ApplicationGatewayResourceId, '/backendAddressPools/', '$BackendAddressPoolName')]"
                }
                backendHttpSettings = @{
                    id = "[concat($ApplicationGatewayResourceId, '/backendHttpSettingsCollection/', '$BackendHttpSettingsName')]"
                }
            }
        }

        $ApplicationGateway.properties.requestRoutingRules += $RequestRoutingRule

        return $ApplicationGateway
    }
}
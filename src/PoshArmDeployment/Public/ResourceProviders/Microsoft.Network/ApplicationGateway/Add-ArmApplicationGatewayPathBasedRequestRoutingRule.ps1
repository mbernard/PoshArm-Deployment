function Add-ArmApplicationGatewayPathBasedRequestRoutingRule {
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
        $UrlPathMapName = 'default'
    )

    $RuleType = 'PathBasedRouting'

    if (!$HttpListenerName) {
        $HttpListenerName = $ApplicationGateway.properties.httpListeners[0].Name
    }

    If ($PSCmdlet.ShouldProcess("Adding path-based routing rule")) {
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

        $RequestRoutingRule.Properties.urlPathMap = @{
            id = "[concat($ApplicationGatewayResourceId, '/urlPathMaps/', '$UrlPathMapName')]"
        }
    }

    $ApplicationGateway.properties.requestRoutingRules += $RequestRoutingRule
    
    return $ApplicationGateway
}
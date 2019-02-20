function Add-ArmApplicationGatewayRedirectRule {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationGateway")]
    Param(
        [PSTypeName("ApplicationGateway")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $ApplicationGateway,
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9]+[a-zA-Z0-9_\-\.]*[a-zA-Z0-9_]+)$')]
        [string]
        $Name = "default",
        [string]
        [ValidateSet("Permanent", "Found", "SeeOther", "Temporary")]
        $RedirectType = "Permanent",
        [Parameter(Mandatory)]
        [string]
        $HttpListenerName,
        [string]
        $TargetListenerName,
        [string]
        $TargetUrl,
        [switch]
        $ExcludePath,
        [switch]
        $ExcludeQueryString
    )

    If ($PSCmdlet.ShouldProcess("Adding redirect rule")) {
        $ApplicationGatewayResourceId = $ApplicationGateway._ResourceId

        $RequestRoutingRule = [PSCustomObject][ordered]@{
            type       = 'Microsoft.Network/applicationGateways/requestRoutingRules'
            name       = $Name
            properties = @{
                ruleType              = "Basic"
                httpListener          = @{
                    id = "[concat($ApplicationGatewayResourceId, '/httpListeners/', '$HttpListenerName')]"
                }
                redirectConfiguration = @{
                    id = "[concat($ApplicationGatewayResourceId, '/redirectConfigurations/', '$Name')]"
                }
            }
        }

        $RedirectConfiguration = [PSCustomObject][ordered]@{
            type       = 'Microsoft.Network/applicationGateways/redirectConfigurations'
            name       = $Name
            properties = @{
                redirectType        = $RedirectType
                includePath         = -not $ExcludePath.toBool()
                includeQueryString  = -not $ExcludeQueryString.toBool()
                requestRoutingRules = @(@{
                        id = "[concat($ApplicationGatewayResourceId, '/requestRoutingRules/', '$Name')]"
                    })
                targetListener      = @{}
                targetUrl           = $Null
            }
        }

        if ($TargetListenerName) {
            $RedirectConfiguration.properties.targetListener = @{
                id = "[concat($ApplicationGatewayResourceId, '/httpListeners/', '$TargetListenerName')]"
            }
        }
        elseif ($TargetUrl) {
            $RedirectConfiguration.properties.targetUrl = $TargetUrl
        }

        $ApplicationGateway.properties.requestRoutingRules += $RequestRoutingRule
        $ApplicationGateway.properties.redirectConfigurations += $RedirectConfiguration

        return $ApplicationGateway
    }
}
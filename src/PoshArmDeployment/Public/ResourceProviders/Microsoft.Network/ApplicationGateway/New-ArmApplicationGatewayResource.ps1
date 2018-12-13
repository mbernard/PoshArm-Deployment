function New-ArmApplicationGatewayResource {
    [CmdletBinding(SupportsShouldProcess = $True)]
    [OutputType("ApplicationGateway")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name,
        [string]
        $ApiVersion = "2018-08-01",
        [string]
        $Location = $script:location,
        [string]
        $Sku = "WAF_v2",
        [PsTypeName("Subnet")]
        $Subnet
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm application gateway resource")) {
        $VnetResourceId = $Subnet._VirtualNetwork._ResourceId

        $ApplicationGateway = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType Microsoft.Network/applicationGateways
            PSTypeName  = "ApplicationGateway"
            type        = 'Microsoft.Network/applicationGateways'
            name        = $Name
            apiVersion  = $ApiVersion
            location    = $Location
            identity = @{
                type = "UserAssigned"
                identityIds = @(
                    "/subscriptions/48c13282-832b-4617-a1b1-6a2ce820921e/resourceGroups/connect-dev-security-eastus2/providers/Microsoft.ManagedIdentity/userAssignedIdentities/testmig"
                )
            }
            properties  = @{
                sku                                 = @{
                    name = $Sku
                    tier = $Sku
                }
                gatewayIPConfigurations             = @(
                    @{
                        name       = "appGatewayIpConfig"
                        type = "Microsoft.Network/applicationGateways/gatewayIPConfigurations"
                        properties = @{
                            subnet = @{
                                id = $Subnet._ResourceId
                            }
                        }
                    }
                )
                sslCertificates                     = @()
                trustedRootCertificates             = @()
                frontendIPConfigurations            = @()
                frontendPorts                       = @()
                backendAddressPools                 = @()
                backendHttpSettingsCollection       = @()
                httpListeners                       = @()
                urlPathMaps                         = @()
                requestRoutingRules                 = @()
                probes                              = @()
                redirectConfigurations              = @()
                webApplicationFirewallConfiguration = @{
                    enabled            = $true
                    firewallMode       = "Detection"
                    ruleSetType        = "OWASP"
                    ruleSetVersion     = "3.0"
                    disabledRuleGroups = @()
                }
                enableHttp2                         = $true
                autoscaleConfiguration              = @{
                    minCapacity = 2
                }
            }
            resources   = @()
            dependsOn   = @(
                "$VnetResourceId"
            )
        }

        $ApplicationGateway.PSTypeNames.Add("ArmResource")
        return $ApplicationGateway
    }
}
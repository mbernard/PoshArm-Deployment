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
        $SkuName = "WAF_v2",
        [string]
        $SkuTier = "WAF_v2",
        [ValidateRange(1, 32)]
        [int]
        $Capacity = 2,
        [PsTypeName("Subnet")]
        $Subnet,
        [switch]
        $DisableFirewall,
        [ValidateSet("Prevention", "Detection")]
        [string]
        $FirewallMode = "Prevention",
        [switch]
        $EnableRequestBodyCheck,
        [ValidateRange(8, 128)]
        [int]
        $MaxRequestBodySizeInKb = 128
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
            properties  = @{
                sku                           = @{
                    name = $SkuName
                    tier = $SkuTier
                }
                gatewayIPConfigurations       = @(
                    @{
                        name       = "appGatewayIpConfig"
                        type       = "Microsoft.Network/applicationGateways/gatewayIPConfigurations"
                        properties = @{
                            subnet = @{
                                id = $Subnet._ResourceId
                            }
                        }
                    }
                )
                sslCertificates               = @()
                trustedRootCertificates       = @()
                frontendIPConfigurations      = @()
                frontendPorts                 = @()
                backendAddressPools           = @()
                backendHttpSettingsCollection = @()
                httpListeners                 = @()
                urlPathMaps                   = @()
                requestRoutingRules           = @()
                probes                        = @()
                redirectConfigurations        = @()
                enableHttp2                   = $true
            }
            resources   = @()
            dependsOn   = @(
                "$VnetResourceId"
            )
        }

        if (!$DisableFirewall.ToBool()) {
            $WebApplicationFirewallConfiguration = @{
                enabled                = $true
                firewallMode           = $FirewallMode
                ruleSetType            = "OWASP"
                ruleSetVersion         = "3.0"
                disabledRuleGroups     = @()
                exclusions             = @()
                requestBodyCheck       = $EnableRequestBodyCheck.ToBool()
                maxRequestBodySizeInKb = $MaxRequestBodySizeInKb
            }
            $ApplicationGateway.properties.Add('webApplicationFirewallConfiguration', $WebApplicationFirewallConfiguration)
        }

        if ($SkuTier.endswith("_v2")) {
            $AutoScaleConfiguration = @{
                minCapacity = $Capacity
            }
            $ApplicationGateway.properties.Add('autoscaleConfiguration', $AutoScaleConfiguration)
        }
        else {
            $ApplicationGateway.properties.sku.Add('capacity', $Capacity)
        }

        $ApplicationGateway.PSTypeNames.Add("ArmResource")
        return $ApplicationGateway
    }
}
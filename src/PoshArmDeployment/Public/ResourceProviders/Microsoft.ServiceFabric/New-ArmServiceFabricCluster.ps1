function New-ArmServiceFabricCluster {
    [CmdletBinding(SupportsShouldProcess = $True)]
    [OutputType("ServiceFabricCluster")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name = "default",
        [string]
        $ApiVersion = '2016-09-01',
        [string]
        $Location = $script:location,
        [string]
        $CertificateThumbprint,
        [string]
        $ReliabilityLevel = "Silver"
    )

    If ($PSCmdlet.ShouldProcess("Creates a new service fabric cluster object")) {
        $serviceFabricCluster = [PSCustomObject][ordered]@{
            _ResourceId = New-ArmFunctionResourceId -ResourceType Microsoft.ServiceFabric/clusters -ResourceName1 $Name
            PSTypeName = "ServiceFabricCluster"
            type       = 'Microsoft.ServiceFabric/clusters'
            name       = $Name
            apiVersion = $ApiVersion
            location   = $Location
            properties = @{
                certificate = @{
                    thumbprint = $CertificateThumbprint
                    x509StoreName = "My"
                }
                clientCertificateCommonNames = @()
                clientCertificateThumbprints = @()
                clusterState = "Default"
                fabricSettings = @(
                    @{
                        parameters = @(
                            @{
                                name = "ClusterProtectionLevel"
                                value = "EncryptAndSign"
                            }
                        )
                        name = "Security"
                    }
                )
                managementEndpoint = "https://google.com" #"[concat('https://',reference(variables('lbIPName')).dnsSettings.fqdn,':',19080))]"
                nodeTypes = @()
                provisioningState = "Default"
                reliabilityLevel = $ReliabilityLevel
                upgradeMode = "Automatic"
                vmImage = "Windows"
            }
            resources  = @()
            dependsOn  = @()
        }

        $serviceFabricCluster.PSTypeNames.Add("ArmResource")
        return $serviceFabricCluster
    }
}
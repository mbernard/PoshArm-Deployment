function New-ArmServiceFabricCluster {
    [CmdletBinding(SupportsShouldProcess = $True)]
    [OutputType("ServiceFabricCluster")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name,
        [string]
        $ApiVersion = '2018-02-01',
        [string]
        $Location = $script:location,
        [Parameter(Mandatory)]
        [string]
        $CertificateThumbprint,
        [string]
        [ValidateSet("Bronze", "Silver", "Gold")]
        $ReliabilityLevel = "Silver",
        [Parameter(Mandatory)]
        [string]
        $ManagementEndpointUrl
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
                addonFeatures = @(
                    "DnsService"
                )
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
                managementEndpoint = $ManagementEndpointUrl
                nodeTypes = @()
                provisioningState = "Default"
                reliabilityLevel = $ReliabilityLevel
                upgradeMode = "Automatic"
                vmImage = "Windows"
                azureActiveDirectory = @{}
            }
            resources  = @()
            dependsOn  = @()
        }

        $serviceFabricCluster.PSTypeNames.Add("ArmResource")
        return $serviceFabricCluster
    }
}
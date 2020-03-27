function New-ArmServiceFabricCluster {
    [CmdletBinding(SupportsShouldProcess = $True)]
    [OutputType("ServiceFabricCluster")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name,
        [string]
        $ApiVersion = '2019-06-01-preview',
        [string]
        $Location = $script:location,
        [Parameter(Mandatory)]
        [string]
        $CertificateThumbprint,
        [string]
        [ValidateSet("None", "Bronze", "Silver", "Gold")]
        $ReliabilityLevel = "Silver",
        [Parameter(Mandatory)]
        [string]
        $ManagementEndpointUrl,
        [Parameter(Mandatory)]
        [string]
        $SupportLogStorageAccountName,
        [Switch]
        $Linux
    )

    If ($PSCmdlet.ShouldProcess("Creates a new service fabric cluster object")) {
        $SupportLogStorageAccountNameExpression = $SupportLogStorageAccountName | ConvertTo-ValueInTemplateExpression
        $serviceFabricCluster = [PSCustomObject][ordered]@{
            _ResourceId = New-ArmFunctionResourceId -ResourceType Microsoft.ServiceFabric/clusters -ResourceName1 $Name
            PSTypeName  = "ServiceFabricCluster"
            type        = 'Microsoft.ServiceFabric/clusters'
            name        = $Name
            apiVersion  = $ApiVersion
            location    = $Location
            properties  = @{
                addonFeatures                   = @()
                certificate                     = @{
                    thumbprint    = $CertificateThumbprint
                    x509StoreName = "My"
                }
                clientCertificateCommonNames    = @()
                clientCertificateThumbprints    = @()
                clusterState                    = "Default"
                fabricSettings                  = @(
                    @{
                        parameters = @(
                            @{
                                name  = "ClusterProtectionLevel"
                                value = "EncryptAndSign"
                            }
                        )
                        name       = "Security"
                    }
                )
                managementEndpoint              = $ManagementEndpointUrl
                nodeTypes                       = @()
                provisioningState               = "Default"
                reliabilityLevel                = $ReliabilityLevel
                upgradeMode                     = "Automatic"
                vmImage                         = if($Linux.ToBool()) { "Linux" } else { "Windows" }
                diagnosticsStorageAccountConfig = @{
                    blobEndpoint            = "[concat('https://',$SupportLogStorageAccountNameExpression,'.blob.core.windows.net/')]"
                    protectedAccountKeyName = "StorageAccountKey1"
                    queueEndpoint           = "[concat('https://',$SupportLogStorageAccountNameExpression,'.queue.core.windows.net/')]"
                    storageAccountName      = $SupportLogStorageAccountName
                    tableEndpoint           = "[concat('https://',$SupportLogStorageAccountNameExpression,'.table.core.windows.net/')]"
                }
            }
            resources   = @()
            dependsOn   = @()
        }

        $serviceFabricCluster.PSTypeNames.Add("ArmResource")
        return $serviceFabricCluster
    }
}
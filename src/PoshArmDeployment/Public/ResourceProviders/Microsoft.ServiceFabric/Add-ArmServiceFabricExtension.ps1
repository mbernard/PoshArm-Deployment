function Add-ArmServiceFabricExtension {
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param(
        [PSTypeName("VirtualMachineScaleSet")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $VirtualMachineScaleSet,
        [PSTypeName("ServiceFabricNodeType")]
        [Parameter(Mandatory)]
        $NodeType,
        [string]
        [Parameter(Mandatory)]
        $SupportLogStorageAccountResourceId,
        [string]
        [Parameter(Mandatory)]
        $CertificateThumbprint
    )

    Process {
        $nodeName = $NodeType.Name
        $sfClusterId = $NodeType._ServiceFabricCluster._ResourceId
        If ($PSCmdlet.ShouldProcess("Adding service fabric extension to a virtual machine scale set")) {
            $SupportLogStorageAccountResourceId = $SupportLogStorageAccountResourceId | ConvertTo-ValueInTemplateExpression

            $sfExtension = @{
                name       = "ServiceFabricNodeVmExt_$nodeName"
                properties = @{
                    type                    = "ServiceFabricNode"
                    autoUpgradeMinorVersion = $true
                    publisher               = "Microsoft.Azure.ServiceFabric"
                    protectedSettings       = @{
                        StorageAccountKey1 = "[listKeys($SupportLogStorageAccountResourceId, '2015-05-01-preview').key1]"
                        StorageAccountKey2 = "[listKeys($SupportLogStorageAccountResourceId, '2015-05-01-preview').key2]"
                    }
                    settings                = @{
                        clusterEndpoint    = "[reference($sfClusterId).clusterEndpoint]"
                        nodeTypeRef        = $VirtualMachineScaleSet.Name
                        dataPath           = "D:\\\\SvcFab"
                        durabilityLevel    = $DurabilityLevel
                        enableParallelJobs = $true
                        nicPrefixOverride  = "10.0.0.0/24"
                        certificate        = @{
                            thumbprint    = $CertificateThumbprint
                            x509StoreName = "My"
                        }
                    }
                    typeHandlerVersion      = "1.1"
                }
            }

            $VirtualMachineScaleSet.properties.virtualMachineProfile.extensionProfile.extensions += $sfExtension
            return $VirtualMachineScaleSet
        }
    }
}
function Add-ArmServiceFabricExtension {
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param(
        [PSTypeName("VirtualMachineScaleSet")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $VirtualMachineScaleSet,
        [PSTypeName("ServiceFabricCluster")]
        [Parameter(Mandatory)]
        $ServiceFabricCluster,
        [string]
        [Parameter(Mandatory)]
        $NodeTypeName,
        [string]
        [Parameter(Mandatory)]
        $SupportLogStorageAccountResourceId,
        [ValidateSet("Bronze", "Silver", "Gold")]        
        [string] 
        $DurabilityLevel = "Bronze" ,
        [string]
        $NicPrefixOverride = "10.0.0.0/24"
    )

    Process {
        If ($PSCmdlet.ShouldProcess("Adding service fabric extension to a virtual machine scale set")) {
            $SupportLogStorageAccountResourceId = $SupportLogStorageAccountResourceId | ConvertTo-ValueInTemplateExpression
            
            $sfExtension = @{
                name       = "ServiceFabricNodeVmExt_$NodeTypeName"
                properties = @{
                    type                    = if ($VirtualMachineScaleSet._IsLinux) { "ServiceFabricLinuxNode" } else { "ServiceFabricNode" }
                    autoUpgradeMinorVersion = $true
                    publisher               = "Microsoft.Azure.ServiceFabric"
                    protectedSettings       = @{
                        StorageAccountKey1 = "[listKeys($SupportLogStorageAccountResourceId, '2015-05-01-preview').key1]"
                        StorageAccountKey2 = "[listKeys($SupportLogStorageAccountResourceId, '2015-05-01-preview').key2]"
                    }
                    settings                = @{
                        clusterEndpoint    = $ServiceFabricCluster._ClusterEndpoint
                        nodeTypeRef        = $NodeTypeName
                        
                        durabilityLevel    = $DurabilityLevel
                        enableParallelJobs = $true
                        nicPrefixOverride  = $NicPrefixOverride
                        certificate        = @{
                            thumbprint    = $ServiceFabricCluster.properties.certificate.thumbprint
                            x509StoreName = $ServiceFabricCluster.properties.certificate.x509StoreName
                        }
                    }
                    typeHandlerVersion      = "1.1"
                }
            }

            if (!$VirtualMachineScaleSet._IsLinux) {
                $sfExtension.properties.settings.dataPath = "D:\\\\SvcFab"
            }

            $VirtualMachineScaleSet.properties.virtualMachineProfile.extensionProfile.extensions += $sfExtension
            return $VirtualMachineScaleSet
        }
    }
}
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
        $CertificateThumbprint
    )

    Process {
        $nodeName = $NodeType.Name
        $sfClusterId = $NodeType._ServiceFabricCluster._ResourceId
        If ($PSCmdlet.ShouldProcess("Adding service fabric extension to a virtual machine")) {
            $sfExtension = @{
                name       = "ServiceFabricNodeVmExt_$nodeName"
                properties = @{
                    type                    = "ServiceFabricNode"
                    autoUpgradeMinorVersion = $true
                    publisher               = "Microsoft.Azure.ServiceFabric"
                    settings                = @{
                        clusterEndpoint = "[reference($sfClusterId).clusterEndpoint]"
                        nodeTypeRef     = $VirtualMachineScaleSet.Name
                        dataPath        = "D:\\\\SvcFab"
                        durabilityLevel = $DurabilityLevel
                        certificate     = @{
                            certificateThumbprint = $CertificateThumbprint
                            x509StoreName         = "My"
                        }
                    }
                    typeHandlerVersion      = "1.0"
                }
            }

            $VirtualMachineScaleSet.properties.virtualMachineProfile.extensionProfile.extensions += $sfExtension
            return $VirtualMachineScaleSet
        }
    }
}
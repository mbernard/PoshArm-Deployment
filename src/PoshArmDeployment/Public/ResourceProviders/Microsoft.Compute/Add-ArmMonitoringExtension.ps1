function Add-ArmMonitoringExtension {
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
        $LogWorkspaceResourceId
    )

    Process {
        $nodeName = $NodeType.Name
        If ($PSCmdlet.ShouldProcess("Adding monitoring extension to a virtual machine scale set")) {
            $monitoringExtension = @{
                name       = "OMSVmExt_$nodeName"
                properties = @{
                    publisher               = "Microsoft.EnterpriseCloud.Monitoring"
                    type                    = "MicrosoftMonitoringAgent"
                    typeHandlerVersion      = "1.0"
                    autoUpgradeMinorVersion = $true
                    settings                = @{
                        workspaceId = "[reference('$LogWorkspaceResourceId', '2015-11-01-preview').customerId]"
                    }
                    protectedSettings       = @{
                        workspacekey = "[listKeys('$LogWorkspaceResourceId', '2015-11-01-preview').primarySharedKey]"
                    }
                }
            }

            $VirtualMachineScaleSet.properties.virtualMachineProfile.extensionProfile.extensions += $monitoringExtension
            return $VirtualMachineScaleSet
        }
    }
}
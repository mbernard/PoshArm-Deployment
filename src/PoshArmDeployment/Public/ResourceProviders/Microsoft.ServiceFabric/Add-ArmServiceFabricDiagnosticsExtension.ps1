function Add-ArmServiceFabricDiagnosticsExtension {
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
        $ApplicationDiagnosticsStorageAccountName,
        [string]
        [Parameter(Mandatory)]
        $ApplicationDiagnosticsStorageAccountResourceId,
        [string]
        [Parameter(Mandatory)]
        $ApplicationInsightsKey
    )

    Process {
        $nodeName = $NodeType.Name
        If ($PSCmdlet.ShouldProcess("Adding service fabric diagnostics extension to a virtual machine scale set")) {
            $ApplicationDiagnosticsStorageAccountResourceId = $ApplicationDiagnosticsStorageAccountResourceId | ConvertTo-ValueInTemplateExpression
            $sfDiagnosticsExtension = @{
                name       = "VMDiagnosticsVmExt_$nodeName"
                properties = @{
                    type                    = "IaaSDiagnostics"
                    autoUpgradeMinorVersion = $true
                    protectedSettings       = @{
                        storageAccountName     = $ApplicationDiagnosticsStorageAccountName
                        storageAccountKey      = "[listKeys($ApplicationDiagnosticsStorageAccountResourceId,'2015-05-01-preview').key1]"
                        storageAccountEndPoint = "https://core.windows.net/"
                    }
                    publisher               = "Microsoft.Azure.Diagnostics"
                    settings                = @{
                        WadCfg         = @{
                            DiagnosticMonitorConfiguration = @{
                                overallQuotaInMB = "50000"
                                sinks            = "applicationInsights"
                                EtwProviders     = @{
                                    EtwEventSourceProviderConfiguration = @(
                                        @{
                                            provider                       = "Microsoft-ServiceFabric-Actors"
                                            scheduledTransferKeywordFilter = "1"
                                            scheduledTransferPeriod        = "PT5M"
                                            DefaultEvents                  = @{
                                                eventDestination = "ServiceFabricReliableActorEventTable"
                                            }
                                        }, @{
                                            provider                = "Microsoft-ServiceFabric-Services"
                                            scheduledTransferPeriod = "PT5M"
                                            DefaultEvents           = @{
                                                eventDestination = "ServiceFabricReliableServiceEventTable"
                                            }
                                        }
                                    )
                                    EtwManifestProviderConfiguration    = @(
                                        @{
                                            provider                        = "cbd93bc2-71e5-4566-b3a7-595d8eeca6e8"
                                            scheduledTransferLogLevelFilter = "Information"
                                            scheduledTransferKeywordFilter  = "4611686018427387904"
                                            scheduledTransferPeriod         = "PT5M"
                                            DefaultEvents                   = @{
                                                eventDestination = "ServiceFabricSystemEventTable"
                                            }
                                        }
                                    )
                                }
                            }
                            SinksConfig                    = @{
                                Sink = @(
                                    @{
                                        name                = "applicationInsights"
                                        ApplicationInsights = $ApplicationInsightsKey
                                    }
                                )
                            }
                        }
                        StorageAccount = $ApplicationDiagnosticsStorageAccountName
                    }
                    typeHandlerVersion      = "1.5"
                }
            }

            $VirtualMachineScaleSet.properties.virtualMachineProfile.extensionProfile.extensions += $sfDiagnosticsExtension
            return $VirtualMachineScaleSet
        }
    }
}
function Add-ArmServiceFabricDiagnosticsExtensionLinux {
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param(
        [PSTypeName("VirtualMachineScaleSet")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $VirtualMachineScaleSet,
        [string]
        [Parameter(Mandatory)]
        $ApplicationDiagnosticsStorageAccountName,
        [string]
        [Parameter(Mandatory)]
        $ApplicationDiagnosticsStorageAccountResourceId
    )

    Process {
        If ($PSCmdlet.ShouldProcess("Adding service fabric diagnostics extension to a virtual machine scale set")) {
            $VmScaleSetResourceId = $VirtualMachineScaleSet._ResourceId
            $xmlConfig = "concat('<WadCfg><DiagnosticMonitorConfiguration><PerformanceCounters scheduledTransferPeriod=\""PT1M\""><PerformanceCounterConfiguration counterSpecifier=\""\\Memory\\AvailableMemory\"" sampleRate=\""PT15S\"" unit=\""Bytes\""><annotation displayName=\""Memory available\"" locale=\""en-us\""/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\""\\Memory\\PercentAvailableMemory\"" sampleRate=\""PT15S\"" unit=\""Percent\""><annotation displayName=\""Mem. percent available\"" locale=\""en-us\""/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\""\\Memory\\UsedMemory\"" sampleRate=\""PT15S\"" unit=\""Bytes\""><annotation displayName=\""Memory used\"" locale=\""en-us\""/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\""\\Memory\\PercentUsedMemory\"" sampleRate=\""PT15S\"" unit=\""Percent\""><annotation displayName=\""Memory percentage\"" locale=\""en-us\""/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\""\\Memory\\PercentUsedByCache\"" sampleRate=\""PT15S\"" unit=\""Percent\""><annotation displayName=\""Mem. used by cache\"" locale=\""en-us\""/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\""\\Processor\\PercentIdleTime\"" sampleRate=\""PT15S\"" unit=\""Percent\""><annotation displayName=\""CPU idle time\"" locale=\""en-us\""/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\""\\Processor\\PercentUserTime\"" sampleRate=\""PT15S\"" unit=\""Percent\""><annotation displayName=\""CPU user time\"" locale=\""en-us\""/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\""\\Processor\\PercentProcessorTime\"" sampleRate=\""PT15S\"" unit=\""Percent\""><annotation displayName=\""CPU percentage guest OS\"" locale=\""en-us\""/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\""\\Processor\\PercentIOWaitTime\"" sampleRate=\""PT15S\"" unit=\""Percent\""><annotation displayName=\""CPU IO wait time\"" locale=\""en-us\""/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\""\\PhysicalDisk\\BytesPerSecond\"" sampleRate=\""PT15S\"" unit=\""BytesPerSecond\""><annotation displayName=\""Disk total bytes\"" locale=\""en-us\""/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\""\\PhysicalDisk\\ReadBytesPerSecond\"" sampleRate=\""PT15S\"" unit=\""BytesPerSecond\""><annotation displayName=\""Disk read guest OS\"" locale=\""en-us\""/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\""\\PhysicalDisk\\WriteBytesPerSecond\"" sampleRate=\""PT15S\"" unit=\""BytesPerSecond\""><annotation displayName=\""Disk write guest OS\"" locale=\""en-us\""/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\""\\PhysicalDisk\\TransfersPerSecond\"" sampleRate=\""PT15S\"" unit=\""CountPerSecond\""><annotation displayName=\""Disk transfers\"" locale=\""en-us\""/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\""\\PhysicalDisk\\ReadsPerSecond\"" sampleRate=\""PT15S\"" unit=\""CountPerSecond\""><annotation displayName=\""Disk reads\"" locale=\""en-us\""/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\""\\PhysicalDisk\\WritesPerSecond\"" sampleRate=\""PT15S\"" unit=\""CountPerSecond\""><annotation displayName=\""Disk writes\"" locale=\""en-us\""/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\""\\PhysicalDisk\\AverageReadTime\"" sampleRate=\""PT15S\"" unit=\""Seconds\""><annotation displayName=\""Disk read time\"" locale=\""en-us\""/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\""\\PhysicalDisk\\AverageWriteTime\"" sampleRate=\""PT15S\"" unit=\""Seconds\""><annotation displayName=\""Disk write time\"" locale=\""en-us\""/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\""\\PhysicalDisk\\AverageTransferTime\"" sampleRate=\""PT15S\"" unit=\""Seconds\""><annotation displayName=\""Disk transfer time\"" locale=\""en-us\""/></PerformanceCounterConfiguration><PerformanceCounterConfiguration counterSpecifier=\""\\PhysicalDisk\\AverageDiskQueueLength\"" sampleRate=\""PT15S\"" unit=\""Count\""><annotation displayName=\""Disk queue length\"" locale=\""en-us\""/></PerformanceCounterConfiguration></PerformanceCounters><Metrics resourceId=\""', $VmScaleSetResourceId, '\""><MetricAggregation scheduledTransferPeriod=\""PT1H\""/><MetricAggregation scheduledTransferPeriod=\""PT1M\""/></Metrics></DiagnosticMonitorConfiguration></WadCfg>')"
           
            $ApplicationDiagnosticsStorageAccountResourceId = $ApplicationDiagnosticsStorageAccountResourceId | ConvertTo-ValueInTemplateExpression
            $sfDiagnosticsExtension = @{
                name       = "VMDiagnosticsVmExt"
                properties = @{
                    type                    = "LinuxDiagnostic"
                    autoUpgradeMinorVersion = $true
                    protectedSettings       = @{
                        storageAccountName     = $ApplicationDiagnosticsStorageAccountName
                        storageAccountKey      = "[listKeys($ApplicationDiagnosticsStorageAccountResourceId,'2015-05-01-preview').key1]"
                        storageAccountEndPoint = "https://core.windows.net/"
                    }
                    publisher               = "Microsoft.OSTCExtensions"
                    typeHandlerVersion      = "2.3"
                    settings                = @{
                        xmlCfg         = "[base64($xmlConfig)]"
                        StorageAccount = $ApplicationDiagnosticsStorageAccountName
                    }
                }
            }

            $VirtualMachineScaleSet.properties.virtualMachineProfile.extensionProfile.extensions += $sfDiagnosticsExtension
            return $VirtualMachineScaleSet
        }
    }
}
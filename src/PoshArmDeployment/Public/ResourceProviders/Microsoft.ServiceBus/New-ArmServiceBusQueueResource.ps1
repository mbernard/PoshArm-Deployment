function New-ArmServiceBusQueueResource {
    [CmdletBinding(SupportsShouldProcess = $True)]
    [OutputType("ServiceBusQueue")]
    Param(
        [Parameter(Mandatory)]
        [ValidatePattern('^(\[.*\]|[A-Za-z0-9]|[A-Za-z0-9][\w-\.\/\~]*[A-Za-z0-9])$')]
        [string]
        $Name,
        [string]
        $ApiVersion = '2017-04-01',
        [string]
        $Location = $script:Location,
        [Parameter(Mandatory, ValueFromPipeline)]
        [String]
        $ServiceBusName,
        [string]
        $LockDuration = "PT30S",
        [int]
        [ValidateSet(1024, 2048, 3072, 4096, 5120)]
        $MaxSizeInMegabytes = 1024,
        [Switch]
        $EnableDuplicateDetection,
        [Switch]
        $EnableSession,
        [string]
        $MessageTimeToLive = "P14D",
        [Switch]
        $DisableDeadLetteringOnMessageExpiration,
        [Switch]
        $DisableBatchedOperations,
        [string]
        $DuplicateDetectionHistoryTimeWindow = "PT10M",
        [int]
        $MaxRetryCount = 10,
        [switch]
        $DisablePartitioning,
        [switch]
        $EnableExpress
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm ServiceBus queue object")) {
        $ServiceBusQueue = [PSCustomObject][ordered]@{
            _ResourceId = New-ArmFunctionResourceId -ResourceType Microsoft.ServiceBus/namespaces/queues -ResourceName1 $ServiceBusName -ResourceName2 $Name
            PSTypeName  = "ServiceBusQueue"
            type        = 'Microsoft.ServiceBus/namespaces/queues'
            name        = "[concat($ServiceBusName, '/$Name')]"
            apiVersion  = $ApiVersion
            location    = $Location
            properties  = @{
                lockDuration                        = $LockDuration
                maxSizeInMegabytes                  = $MaxSizeInMegabytes
                requiresDuplicateDetection          = $EnableDuplicateDetection.ToBool()
                requiresSession                     = $EnableSession.ToBool()
                defaultMessageTimeToLive            = $MessageTimeToLive
                deadLetteringOnMessageExpiration    = -not $DisableDeadLetteringOnMessageExpiration.ToBool()
                enableBatchedOperations             = -not $DisableBatchedOperations.ToBool()
                duplicateDetectionHistoryTimeWindow = $DuplicateDetectionHistoryTimeWindow
                maxDeliveryCount                    = $MaxRetryCount
                status                              = "Active"
                autoDeleteOnIdle                    = "P10675199DT2H48M5.4775807S"
                enablePartitioning                  = -not $DisablePartitioning.ToBool()
                enableExpress                       = $EnableExpress.ToBool()
            }
            resources   = @()
            dependsOn   = @()
        }

        $ServiceBusQueue.PSTypeNames.Add("ArmResource")
        return $ServiceBusQueue
    }
}
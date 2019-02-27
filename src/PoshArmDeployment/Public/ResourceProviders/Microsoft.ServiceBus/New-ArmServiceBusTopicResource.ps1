function New-ArmServiceBusTopicResource {
    [CmdletBinding(SupportsShouldProcess = $True)]
    [OutputType("ServiceBusTopic")]
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
        [int]
        $MaxSizeInMegabytes = 1024,
        [Switch]
        $EnableDuplicateDetection,
        [string]
        $MessageTimeToLive = "P14D",
        [Switch]
        $DisableBatchedOperations,
        [string]
        $DuplicateDetectionHistoryTimeWindow = "PT10M",
        [switch]
        $DisablePartitioning,
        [switch]
        $EnableExpress,
        [switch]
        $EnableOrderingSupport
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm ServiceBus Topic object")) {
        $ServiceBusTopic = [PSCustomObject][ordered]@{
            _ResourceId = New-ArmFunctionResourceId -ResourceType Microsoft.ServiceBus/namespaces/topics -ResourceName1 $ServiceBusName -ResourceName2 $Name
            PSTypeName  = "ServiceBusTopic"
            type        = 'Microsoft.ServiceBus/namespaces/topics'
            name        = "[concat($ServiceBusName, '/$Name')]"
            apiVersion  = $ApiVersion
            location    = $Location
            properties  = @{
                defaultMessageTimeToLive            = $MessageTimeToLive
                maxSizeInMegabytes                  = $MaxSizeInMegabytes
                requiresDuplicateDetection          = $EnableDuplicateDetection.ToBool()
                duplicateDetectionHistoryTimeWindow = $DuplicateDetectionHistoryTimeWindow
                enableBatchedOperations             = -not $DisableBatchedOperations.ToBool()
                status                              = "Active"
                supportOrdering                     = $EnableOrderingSupport.ToBool()
                autoDeleteOnIdle                    = "P10675199DT2H48M5.4775807S"
                enablePartitioning                  = -not $DisablePartitioning.ToBool()
                enableExpress                       = $EnableExpress.ToBool()
            }
            resources   = @()
            dependsOn   = @()
        }

        $ServiceBusTopic.PSTypeNames.Add("ArmResource")
        return $ServiceBusTopic
    }
}
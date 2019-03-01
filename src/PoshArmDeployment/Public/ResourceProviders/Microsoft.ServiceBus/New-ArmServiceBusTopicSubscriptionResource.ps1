function New-ArmServiceBusTopicSubscriptionResource {
    [CmdletBinding(SupportsShouldProcess = $True)]
    [OutputType("ServiceBusTopicSubscription")]
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
        [PSTypeName("ServiceBusTopic")]
        $Topic,
        [string]
        $LockDuration = "PT30S",
        [Switch]
        $EnableSession,
        [string]
        $MessageTimeToLive = "P14D",
        [Switch]
        $DisableDeadLetteringOnMessageExpiration,
        [Switch]
        $DisableBatchedOperations,
        [int]
        $MaxRetryCount = 10,
        [switch]
        $DeadLetteringOnFilterEvaluationExceptions
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm ServiceBus topic subscription object")) {
        $TopicName = $Topic.Name
        $ServiceBusTopicSubscription = [PSCustomObject][ordered]@{
            _ResourceId = New-ArmFunctionResourceId -ResourceType Microsoft.ServiceBus/namespaces/topics/subscriptions -ResourceName1 $TopicName -ResourceName2 $Name
            PSTypeName  = "ServiceBusTopicSubscription"
            type        = 'Microsoft.ServiceBus/namespaces/topics/subscriptions'
            name        = "[concat($TopicName, '/$Name')]"
            apiVersion  = $ApiVersion
            location    = $Location
            properties  = @{
                lockDuration                              = $LockDuration
                requiresSession                           = $EnableSession.ToBool()
                defaultMessageTimeToLive                  = $MessageTimeToLive
                deadLetteringOnMessageExpiration          = -not $DisableDeadLetteringOnMessageExpiration.ToBool()
                deadLetteringOnFilterEvaluationExceptions = -not $DeadLetteringOnFilterEvaluationExceptions.ToBool()
                maxDeliveryCount                          = $MaxRetryCount
                status                                    = "Active"
                enableBatchedOperations                   = -not $DisableBatchedOperations.ToBool()
                autoDeleteOnIdle                          = "P10675199DT2H48M5.4775807S"
            }
            resources   = @()
            dependsOn   = @()
        }

        $ServiceBusTopicSubscription.PSTypeNames.Add("ArmResource")
        return $ServiceBusTopicSubscription
    }
}
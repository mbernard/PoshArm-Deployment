function New-ArmServiceBusTopicSubscriptionFilterResource {
    [CmdletBinding(SupportsShouldProcess = $True)]
    [OutputType("ServiceBusTopicSubscriptionFilter")]
    Param(
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9]*)$')]
        [string]
        $Name = "$$Default",
        [string]
        $ApiVersion = '2017-04-01',
        [string]
        $Location = $script:Location,
        [Parameter(Mandatory, ValueFromPipeline)]
        [String]
        $TopicSubscriptionName,
        [Parameter(Mandatory)]
        [string]
        $SqlExpressions
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm ServiceBus topic subscription filter object")) {
        $ServiceBusTopicSubscriptionFilter = [PSCustomObject][ordered]@{
            _ResourceId = New-ArmFunctionResourceId -ResourceType Microsoft.ServiceBus/namespaces/topics/subscriptions/rules -ResourceName1 $TopicSubscriptionName -ResourceName2 $Name
            PSTypeName  = "ServiceBusTopicSubscriptionFilter"
            type        = 'Microsoft.ServiceBus/namespaces/topics/subscriptions/rules'
            name        = "[concat($TopicSubscriptionName, '/$Name')]"
            apiVersion  = $ApiVersion
            location    = $Location
            properties  = @{
                action = @{}
                filterType = "SqlFilter"
                sqlFilter = @{
                    sqlExpression = $SqlExpression
                }
            }
            resources   = @()
            dependsOn   = @()
        }

        $ServiceBusTopicSubscriptionFilter.PSTypeNames.Add("ArmResource")
        return $ServiceBusTopicSubscriptionFilter
    }
}
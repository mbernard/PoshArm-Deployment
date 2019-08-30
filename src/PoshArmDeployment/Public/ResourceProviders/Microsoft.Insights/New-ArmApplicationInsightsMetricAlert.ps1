function New-ArmApplicationInsightsMetricAlert {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsMetricAlert")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name,
        [Parameter(Mandatory)]
        [PSTypeName("ApplicationInsights")]
        $ApplicationInsights,
        [string]
        $ApiVersion = '2018-03-01',
        [string]
        $Description = "",
        [switch]
        $Disabled,
        [string]
        $Operator,
        [int]
        $Threshold,
        [string]
        $TimeAggregation,
        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $FailedLocationCount,
        [ValidateRange(5, 1440)]
        [int]
        $WindowSizeInMinutes = 5,
        [PSCustomObject]
        $DataSource = @{ },
        [ValidateRange(0, 4)]
        [int]
        $Severity = 0,
        [ValidateRange(1, 60)]
        [int]
        $EvaluationFrequencyInMinutes = 1,
        [string]
        $ActionGroupId = ""

    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm Application Insights metric alert")) {
        $windowSize = "PT$WindowSizeInMinutes" + "M"
        $evaluationFrequency = "PT$EvaluationFrequencyInMinutes" + "M"

        $ApplicationInsightsMetricAlert = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType 'Microsoft.Insights/metricAlerts'
            PSTypeName  = "ApplicationInsightsMetricAlert"
            type        = 'Microsoft.Insights/metricAlerts'
            name        = $Name
            apiVersion  = $ApiVersion
            location    = 'global'
            properties  = @{
                description         = $Description
                severity            = $Severity
                enabled             = -not $Disabled.ToBool()
                scopes              = @("/subscriptions/11f14ab1-a50f-462f-8c65-13584eb3a544/resourceGroups/connect-dhorodniczy-monitoring-eastus2/providers/microsoft.insights/webtests/Connect-ai-bumt3j5t63e7c",
                                        "/subscriptions/11f14ab1-a50f-462f-8c65-13584eb3a544/resourceGroups/connect-dhorodniczy-monitoring-eastus2/providers/microsoft.insights/components/ai-bumt3j5t63e7c"
                )
                evaluationFrequency = $evaluationFrequency
                windowSize          = $windowSize
                criteria            = [PSCustomObject]@{
                    "odata.type" = "Microsoft.Azure.Monitor.WebtestLocationAvailabilityCriteria"
                    webTestId = "/subscriptions/11f14ab1-a50f-462f-8c65-13584eb3a544/resourceGroups/connect-dhorodniczy-monitoring-eastus2/providers/microsoft.insights/webtests/Connect-ai-bumt3j5t63e7c"
                    componentId = "/subscriptions/11f14ab1-a50f-462f-8c65-13584eb3a544/resourceGroups/connect-dhorodniczy-monitoring-eastus2/providers/microsoft.insights/components/ai-bumt3j5t63e7c"
                    failedLocationCount = 3

                }
                actions             = @([PSCustomObject]@{
                        actionGroupId = "/subscriptions/11f14ab1-a50f-462f-8c65-13584eb3a544/resourceGroups/connect-dhorodniczy-monitoring-eastus2/providers/microsoft.insights/actionGroups/MyNewActionGroup-4f4o7ga7r6uzy"
                    })
            }
            dependsOn   = @("/subscriptions/11f14ab1-a50f-462f-8c65-13584eb3a544/resourceGroups/connect-dhorodniczy-monitoring-eastus2/providers/microsoft.insights/webtests/Connect-ai-bumt3j5t63e7c",
                "/subscriptions/11f14ab1-a50f-462f-8c65-13584eb3a544/resourceGroups/connect-dhorodniczy-monitoring-eastus2/providers/microsoft.insights/components/ai-bumt3j5t63e7c",
                "/subscriptions/11f14ab1-a50f-462f-8c65-13584eb3a544/resourceGroups/connect-dhorodniczy-monitoring-eastus2/providers/microsoft.insights/actionGroups/MyNewActionGroup-4f4o7ga7r6uzy")
        }

        $ApplicationInsightsMetricAlert.PSTypeNames.Add("ArmResource")
        return $ApplicationInsightsMetricAlert
    }
}
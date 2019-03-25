function New-ArmApplicationInsightsAlertRule {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsAlertRule")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name,
        [Parameter(Mandatory)]
        [PSTypeName("ApplicationInsights")]
        $ApplicationInsights,
        [string]
        $ApiVersion = '2016-03-01',
        [string]
        $Description = "",
        [switch]
        $Disable,
        [ValidateSet(
            "GreaterThan",
            "GreaterThanOrEqual",
            "LessThan",
            "LessThanOrEqual")]
        [string]
        $Operator,
        [int]
        $Threshold,
        [ValidateSet(
            "Average",
            "Minimum",
            "Maximum",
            "Total",
            "Last")]
        [string]
        $TimeAggregation,
        [int]
        $FailedLocationCount,
        [string]
        $WindowSize = "PT5M",
        [ValidateSet(
            "RuleCondition",
            "Microsoft.Azure.Management.Insights.Models.ThresholdRuleCondition",
            "Microsoft.Azure.Management.Insights.Models.LocationThresholdRuleCondition",
            "Microsoft.Azure.Management.Insights.Models.ManagementEventRuleCondition")]
        [string]
        $ConditionOdataType,
        [PSCustomObject]
        $DataSource = @{}
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm Application Insights alert rule")) {
        $ApplicationInsightsAlertRule = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType 'microsoft.insights/alertrules'
            PSTypeName  = "ApplicationInsightsAlertRule"
            type        = 'microsoft.insights/alertrules'
            name        = $Name
            apiVersion  = $ApiVersion
            location    = $ApplicationInsights.location
            properties  = @{
                name        = $Name
                description = $Description
                isEnabled   = -not $Disable.ToBool()
                condition   = @{
                    "odata.type"        = $ConditionOdataType
                    dataSource          = $DataSource
                    windowSize          = $WindowSize
                    failedLocationCount = $FailedLocationCount
                    operator            = $Operator
                    threshold           = $Threshold
                    timeAggregation     = $TimeAggregation
                }
                actions     = @()
            }
            dependsOn   = @()
        }

        $ApplicationInsightsAlertRule.PSTypeNames.Add("ArmResource")
        return $ApplicationInsightsAlertRule
    }
}
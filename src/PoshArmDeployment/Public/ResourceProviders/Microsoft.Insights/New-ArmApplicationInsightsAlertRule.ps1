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
        $Disabled,
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
        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $FailedLocationCount,
        [ValidateRange(5, 1440)]
        [int]
        $WindowSizeInMinutes = 5,
        [ValidateSet(
            "RuleCondition",
            "ThresholdRule",
            "LocationThresholdRule",
            "ManagementEventRule")]
        [string]
        $Condition,
        [PSCustomObject]
        $DataSource = @{}
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm Application Insights alert rule")) {
        $conditionOdataType = switch ($Condition) {
            'RuleCondition' { 'RuleCondition' }
            'ThresholdRule' { 'Microsoft.Azure.Management.Insights.Models.ThresholdRuleCondition' }
            'LocationThresholdRule' { 'Microsoft.Azure.Management.Insights.Models.LocationThresholdRuleCondition' }
            'ManagementEventRule' { 'Microsoft.Azure.Management.Insights.Models.ManagementEventRuleCondition' }
        }

        $windowSize = "PT$WindowSizeInMinutes" + "M"

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
                isEnabled   = -not $Disabled.ToBool()
                condition   = @{
                    "odata.type"        = $conditionOdataType
                    dataSource          = $DataSource
                    windowSize          = $windowSize
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
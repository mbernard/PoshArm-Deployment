# https://docs.microsoft.com/en-us/azure/azure-monitor/platform/metrics-supported
function Add-ArmApplicationInsightsMetricAlertStaticCriteria {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsMetricAlert")]
    Param(
        [PSTypeName("ApplicationInsightsMetricAlert")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $MetricAlert,
        [string]
        [Parameter(Mandatory)]
        $Name,
        [string]
        [Parameter(Mandatory)]
        $MetricName,
        [string]
        [Parameter(Mandatory)]
        $MetricNamespace,
        [PSCustomObject[]]
        $Dimensions = @(),
        [string]
        [Parameter(Mandatory)]
        [ValidateSet("Equals", "NotEquals", "GreaterThan", "GreaterThanOrEqual", "LessThan", "LessThanOrEqual")]
        $Operator,
        [int]
        [Parameter(Mandatory)]
        $Threshold,
        [string]
        [Parameter(Mandatory)]
        [ValidateSet("Average", "Minimum", "Maximum", "Total", "Count")]
        $TimeAggregation
    )

    if ($PSCmdlet.ShouldProcess("Adding allOf criteria to Application Insights Metric Alert")) {
        $MetricAlert.properties.criteria.allOf +=
        @{
            criterionType   = "StaticThresholdCriterion"
            name            = $Name
            metricName      = $MetricName
            metricNamespace = $MetricNamespace
            dimensions      = $Dimensions
            operator        = $Operator
            threshold       = $Threshold
            timeAggregation = $TimeAggregation
        }
    }

    return $MetricAlert
}
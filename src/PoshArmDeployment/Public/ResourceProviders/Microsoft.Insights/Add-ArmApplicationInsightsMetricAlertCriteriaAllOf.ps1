function Add-ArmApplicationInsightsMetricAlertCriteriaAllOf {
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
        [string]
        [Parameter(Mandatory)]
        [ValidateSet("Equals", "NotEquals", "GreaterThan", "GreaterThanOrEqual", "LessThan", "LessThanOrEqual")]
        $Operator,
        [string]
        [Parameter(Mandatory)]
        $Threshold,
        [string]
        [Parameter(Mandatory)]
        [ValidateSet("Average", "Minimum", "Maximum", "Total")]
        $TimeAggregation
    )
    
    if ($PSCmdlet.ShouldProcess("Adding allOf criteria to Application Insights Metric Alert")) {
        $MetricAlert.properties.criteria.allOf += @(
            @{
                name            = $Name
                metricName      = $MetricName
                metricNamespace = $MetricNamespace
                dimensions      = @()
                operator        = $Operator
                threshold       = $Threshold
                timeAggregation = $TimeAggregation
            }
        )
    }
    
    return $MetricAlert
}
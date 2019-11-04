function Add-ArmApplicationInsightsMetricAlertCriteriaODataType {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsMetricAlert")]
    Param(
        [PSTypeName("ApplicationInsightsMetricAlert")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $MetricAlert,
        [string]
        $ODataType = "Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria"
    )
    
    If ($PSCmdlet.ShouldProcess("Adding OData Type criteria to Application Insights Metric Alert")) {
        $MetricAlert.properties.criteria["odata.type"] = $ODataType
    }

    return $MetricAlert
}
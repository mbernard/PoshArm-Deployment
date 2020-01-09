function Add-ArmApplicationInsightsMetricAlertAction {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsMetricAlert")]
    Param(
        [PSTypeName("ApplicationInsightsMetricAlert")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $MetricAlert,
        [PSTypeName("ApplicationInsightsActionGroup")]
        [Parameter(Mandatory)]
        $ActionGroup
    )

    If ($PSCmdlet.ShouldProcess("Adding action to Application Insights Metric Alert")) {
        $ActionGroupResourceId = $ActionGroup._ResourceId
        $MetricAlert.properties.actions +=
        [PSCustomObject]@{
            actionGroupId = $ActionGroupResourceId
        }

        $MetricAlert | Add-ArmDependencyOn -Dependency $ActionGroup
    }

    return $MetricAlert
}
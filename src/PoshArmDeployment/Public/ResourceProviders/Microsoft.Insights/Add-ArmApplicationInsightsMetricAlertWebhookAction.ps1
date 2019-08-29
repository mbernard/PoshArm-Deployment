function Add-ArmApplicationInsightsMetricAlertWebhookAction {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsMetricAlert")]
    Param(
        [PSTypeName("ApplicationInsightsMetricAlert")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $ApplicationInsightsMetricAlert,
        [Parameter(Mandatory)]
        [string]
        $Webhook,
        [PSCustomObject]
        $Properties
    )

    If ($PSCmdlet.ShouldProcess("Adding alert rule webhook action")) {
        $metricAlertEmailAction = @{
            "odata.type" = "Microsoft.Azure.Management.Insights.Models.RuleWebhookAction"
            serviceUri   = $Webhook
            properties   = $Properties
        }

        $ApplicationInsightsMetricAlert.properties.actions += $metricAlertEmailAction

        return $ApplicationInsightsMetricAlert
    }
}
function Add-ArmApplicationInsightsAlertRuleWebhookAction {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsAlertRule")]
    Param(
        [PSTypeName("ApplicationInsightsAlertRule")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $ApplicationInsightsAlertRule,
        [Parameter(Mandatory)]
        [string]
        $Webhook,
        [PSCustomObject]
        $Properties
    )

    If ($PSCmdlet.ShouldProcess("Adding alert rule webhook action")) {
        $alertRuleEmailAction = @{
            "odata.type" = "Microsoft.Azure.Management.Insights.Models.RuleWebhookAction"
            serviceUri   = $Webhook
            properties   = $Properties
        }

        $ApplicationInsightsAlertRule.properties.actions += $alertRuleEmailAction

        return $ApplicationInsightsAlertRule
    }
}
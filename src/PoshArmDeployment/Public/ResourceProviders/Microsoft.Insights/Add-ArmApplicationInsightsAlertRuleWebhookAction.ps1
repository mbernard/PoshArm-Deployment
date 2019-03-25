function Add-ArmApplicationInsightsAlertRuleWebhookAction {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsAlertRule")]
    Param(
        [PSTypeName("ApplicationInsightsAlertRule")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $ApplicationInsightsAlertRule,
        [Parameter(Mandatory)]
        [string]
        $ServiceUri,
        [PSCustomObject]
        $Properties
    )

    If ($PSCmdlet.ShouldProcess("Adding alert rule webhook action")) {
        $alertRuleEmailAction = @{
            "odata.type" = "Microsoft.Azure.Management.Insights.Models.RuleWebhookAction"
            serviceUri   = $ServiceUri
            properties   = $Properties
        }

        $ApplicationInsightsAlertRule.properties.actions += $alertRuleEmailAction

        return $ApplicationInsightsAlertRule
    }
}
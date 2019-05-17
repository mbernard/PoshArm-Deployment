function Add-ArmApplicationInsightsAlertRuleEmailAction {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsAlertRule")]
    Param(
        [PSTypeName("ApplicationInsightsAlertRule")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $ApplicationInsightsAlertRule,
        [switch]
        $SendToServiceOwners,
        [string[]]
        $CustomEmails = @()
    )

    If ($PSCmdlet.ShouldProcess("Adding alert rule email action")) {
        $alertRuleEmailAction = @{
            "odata.type"        = "Microsoft.Azure.Management.Insights.Models.RuleEmailAction"
            sendToServiceOwners = $SendToServiceOwners.ToBool()
            customEmails        = $CustomEmails
        }

        $ApplicationInsightsAlertRule.properties.actions += $alertRuleEmailAction

        return $ApplicationInsightsAlertRule
    }
}
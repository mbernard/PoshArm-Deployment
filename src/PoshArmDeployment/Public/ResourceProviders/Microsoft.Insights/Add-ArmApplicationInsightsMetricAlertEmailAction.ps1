function Add-ArmApplicationInsightsMetricAlertEmailAction {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsMetricAlert")]
    Param(
        [PSTypeName("ApplicationInsightsMetricAlert")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $ApplicationInsightsMetricAlert,
        [switch]
        $SendToServiceOwners,
        [string[]]
        $CustomEmails = @()
    )

    If ($PSCmdlet.ShouldProcess("Adding metric alert email action")) {
        $alertRuleEmailAction = @{
            "odata.type"        = "Microsoft.Azure.Management.Insights.Models.RuleEmailAction"
            sendToServiceOwners = $SendToServiceOwners.ToBool()
            customEmails        = $CustomEmails
        }

        $ApplicationInsightsMetricAlert.properties.actions += $alertRuleEmailAction

        return $ApplicationInsightsMetricAlert
    }
}
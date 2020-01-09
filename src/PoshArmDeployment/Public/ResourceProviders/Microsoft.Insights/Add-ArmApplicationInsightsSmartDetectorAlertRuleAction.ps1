function Add-ArmApplicationInsightsSmartDetectorAlertRuleAction {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsSmartDetectorAlertRule")]
    Param(
        [PSTypeName("ApplicationInsightsSmartDetectorAlertRule")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $SmartDetectorAlertRule,
        [PSTypeName("ApplicationInsightsActionGroup")]
        [Parameter(Mandatory)]
        $ActionGroup
    )

    If ($PSCmdlet.ShouldProcess("Adding action to Application Insights Metric Alert")) {
        $ActionGroupResourceId = $ActionGroup._ResourceId
        $SmartDetectorAlertRule.properties.actionGroups.groupIds += $ActionGroupResourceId
        $SmartDetectorAlertRule | Add-ArmDependencyOn -Dependency $ActionGroup
    }

    return $SmartDetectorAlertRule
}
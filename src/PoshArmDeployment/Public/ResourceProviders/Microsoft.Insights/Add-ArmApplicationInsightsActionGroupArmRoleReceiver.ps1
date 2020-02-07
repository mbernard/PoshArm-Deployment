function Add-ArmApplicationInsightsActionGroupArmRoleReceiver {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsActionGroup")]
    Param(
        [PSTypeName("ApplicationInsightsActionGroup")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $ActionGroup,
        [Parameter(Mandatory)]
        [string]
        $Name,
        [Parameter(Mandatory)]
        [string]
        $RoleId,
        [switch]
        $DisableCommonAlertSchema
    )

    If ($PSCmdlet.ShouldProcess("Adding ARM role receiver to Application Insights Action Group")) {
        $ActionGroup.properties.armRoleReceivers +=
        @{
            name                 = $Name
            roleId               = $RoleId
            useCommonAlertSchema = -not $DisableCommonAlertSchema.ToBool()
        }
    }
    return $ActionGroup
}
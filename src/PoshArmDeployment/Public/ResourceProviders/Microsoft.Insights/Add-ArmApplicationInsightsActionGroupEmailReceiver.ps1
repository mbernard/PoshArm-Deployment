function Add-ArmApplicationInsightsActionGroupEmailReceiver {
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
        [ValidatePattern("^(?("")("".+?(?<!\\)""@)|(([0-9a-z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-z])@))(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-z][-0-9a-z]*[0-9a-z]*\.)+[a-z0-9][\-a-z0-9]{0,22}[a-z0-9]))$")]
        [string]
        $EmailAddress,
        [switch]
        $DisableCommonAlertSchema
    )

    If ($PSCmdlet.ShouldProcess("Adding email receiver to Application Insights Action Group")) {
        $ActionGroup.properties.emailReceivers +=
        @{
            name                 = $Name
            emailAddress         = $EmailAddress
            useCommonAlertSchema = -not $DisableCommonAlertSchema.ToBool()
        }
    }

    return $ActionGroup
}
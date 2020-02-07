function Add-ArmApplicationInsightsActionGroupWebHookReceiver {
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
        $ServiceUri
    )
    
    If ($PSCmdlet.ShouldProcess("Adding WebHook receiver to Application Insights Action Group")) {
        $ActionGroup.properties.webHookReceivers += [PSCustomObject]@{
            useCommonAlertSchema = $true
            name                 = $Name
            serviceUri           = $ServiceUri
        }
    }

    return $ActionGroup
}
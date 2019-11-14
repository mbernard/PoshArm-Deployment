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
        $ServiceUri,
        [switch]
        $DisableCommonAlertSchema
    )
    
    If ($PSCmdlet.ShouldProcess("Adding webhook receiver to Application Insights Action Group")) {
        $ActionGroup.properties.webHookReceivers += 
        @{
            name                 = $Name
            serviceUri           = $ServiceUri
            useCommonAlertSchema = -not $DisableCommonAlertSchema.ToBool()
        }
    }
    return $ActionGroup
}
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
        [ValidatePattern("[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")]
        [string]
        $EmailAddress,
        [switch]
        $DisableCommonAlertSchema
    )
    
    If ($PSCmdlet.ShouldProcess("Adding email receiver to Application Insights Action Group")) {
        $ActionGroup.properties.emailReceivers += @(@{
            name                 = $Name
            emailAddress         = $EmailAddress
            useCommonAlertSchema = -not $DisableCommonAlertSchema.ToBool()
        })
    }

    return $ActionGroup
}
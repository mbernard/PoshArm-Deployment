function New-ArmApplicationInsightsActionGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsActionGroup")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]
        $Name,
        [string]
        $GroupShortName,
        [string]
        $WebHookServiceUri,
        [string]
        $WebHookName,
        [switch]
        $Disabled
    )
    If ($PSCmdlet.ShouldProcess("Creates a new Arm Application Insights resource")) {
        $ApplicationInsightsActionGroup = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType 'microsoft.insights/actionGroups'
            PSTypeName  = "ApplicationInsights"
            type        = 'microsoft.insights/actionGroups'
            name        = $Name
            apiVersion  = '2019-03-01'
            location    = 'global'
            properties  = @{
                groupShortName   = $GroupShortName
                enabled          = -not $Disabled.ToBool()
                webHookReceivers = @([PSCustomObject]@{
                        name                 = $WebHookName
                        serviceUri           = $WebHookServiceUri
                        useCommonAlertSchema = $true
                    })
            }
            resources   = @()
            dependsOn   = @()
        }

        $ApplicationInsightsActionGroup.PSTypeNames.Add("ArmResource")
        return $ApplicationInsightsActionGroup
    }
}

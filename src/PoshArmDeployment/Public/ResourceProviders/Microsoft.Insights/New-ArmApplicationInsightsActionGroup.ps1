function New-ArmApplicationInsightsActionGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsActionGroup")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]
        $Name,
        [switch]
        $Disabled,
        [Parameter(Mandatory)]
        [PSCustomObject]
        $DataSource = @{ }
    )
    If ($PSCmdlet.ShouldProcess("Creates a new Arm Application Insights resource")) {
        
        Set-Variable ResourceType -option Constant -value "Microsoft.Insights/actionGroups"

        $ApplicationInsightsActionGroup = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType $ResourceType
            PSTypeName  = "ApplicationInsights"
            type        = $ResourceType
            name        = $Name
            apiVersion  = '2019-03-01'
            location    = 'global'
            properties  = @{
                groupShortName   = $DataSource.ActionGroupShortName.ToString()
                enabled          = -not $Disabled.ToBool()
                webHookReceivers = @([PSCustomObject]@{
                        name                 = $DataSource.WebHookName.ToString()
                        serviceUri           = $DataSource.WebHookServiceUri.ToString()
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

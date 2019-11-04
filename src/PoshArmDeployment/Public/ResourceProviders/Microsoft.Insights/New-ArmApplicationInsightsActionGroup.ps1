function New-ArmApplicationInsightsActionGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsActionGroup")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]
        $Name,
        [Parameter(Mandatory)]
        [string]
        $ShortName,
        [string]
        $ApiVersion = '2019-03-01',
        [switch]
        $Disabled
    )
    If ($PSCmdlet.ShouldProcess("Creates a new Arm Application Insights Action Group")) {
        $ResourceType = "Microsoft.Insights/actionGroups"
        $ApplicationInsightsActionGroup = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType $ResourceType
            PSTypeName  = "ApplicationInsightsActionGroup"
            type        = $ResourceType
            name        = $Name
            apiVersion  = $ApiVersion
            location    = 'global'
            properties  = @{
                groupShortName   = $ShortName
                enabled          = -not $Disabled.ToBool()
                emailReceivers = @()
                webHookReceivers = @()
            }
            resources   = @()
            dependsOn   = @()
        }

        $ApplicationInsightsActionGroup.PSTypeNames.Add("ArmResource")
        return $ApplicationInsightsActionGroup
    }
}

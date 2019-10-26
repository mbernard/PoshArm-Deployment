function New-ArmApplicationInsightsResource {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsights")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name,
        [string]
        $ApiVersion = '2015-05-01',
        [string]
        $Location = $script:Location
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm Application Insights resource")) {
        $ApplicationInsightsResourceId = $Name | New-ArmFunctionResourceId -ResourceType 'microsoft.insights/components'
        $ApplicationInsights = [PSCustomObject][ordered]@{
            _ResourceId = $ApplicationInsightsResourceId
            _InstrumentationKey = "[reference($ApplicationInsightsResourceId).InstrumentationKey]"
            PSTypeName  = "ApplicationInsights"
            type        = 'microsoft.insights/components'
            name        = $Name
            apiVersion  = $ApiVersion
            location    = $Location
            kind        = "other"
            properties = @{}
            resources   = @()
            dependsOn   = @()
        }

        $ApplicationInsights.PSTypeNames.Add("ArmResource")
        return $ApplicationInsights
    }
}
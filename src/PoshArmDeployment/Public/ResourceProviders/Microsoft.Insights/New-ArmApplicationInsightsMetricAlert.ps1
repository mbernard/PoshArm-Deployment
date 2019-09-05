function New-ArmApplicationInsightsMetricAlert {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsMetricAlert")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name,
        [string]
        $ApiVersion = '2018-03-01',
        [string]
        $Description = "",
        [ValidateRange(5, 1440)]
        [int]
        $WindowSizeInMinutes = 5,
        [ValidateRange(0, 4)]
        [int]
        $Severity = 3,
        [ValidateRange(1, 60)]
        [int]
        $EvaluationFrequencyInMinutes = 1,
        [switch]
        $Disabled
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm Application Insights metric alert")) {

        $ResourceType = "Microsoft.Insights/metricAlerts"

        $WindowSize = "PT$WindowSizeInMinutes" + "M"
        $EvaluationFrequency = "PT$EvaluationFrequencyInMinutes" + "M"

        $ApplicationInsightsMetricAlert = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType $ResourceType
            PSTypeName  = "ApplicationInsightsMetricAlert"
            type        = $ResourceType
            name        = $Name
            apiVersion  = $ApiVersion
            location    = 'global'
            properties  = @{
                description         = $Description
                severity            = $Severity
                enabled             = -not $Disabled.ToBool()
                scopes              = @()
                evaluationFrequency = $EvaluationFrequency
                windowSize          = $WindowSize
                criteria            = @{ }
                actions             = @()
            }
            dependsOn   = @()
        }

        $ApplicationInsightsMetricAlert.PSTypeNames.Add("ArmResource")
        return $ApplicationInsightsMetricAlert
    }
}
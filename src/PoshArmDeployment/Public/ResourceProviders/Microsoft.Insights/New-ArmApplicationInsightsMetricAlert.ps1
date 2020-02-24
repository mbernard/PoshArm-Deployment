# https://docs.microsoft.com/en-us/rest/api/monitor/metricalerts/createorupdate
function New-ArmApplicationInsightsMetricAlert {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsMetricAlert")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name,
        [string]
        $Description = "",
        [ValidateRange(1, 1440)]
        [int]
        $WindowSizeInMinutes = 5,
        [ValidateRange(0, 4)]
        [int]
        $Severity = 3,
        [ValidateRange(1, 60)]
        [int]
        $EvaluationFrequencyInMinutes = 1,
        [string[]]
        $Scopes = @(),
        [string]
        $ApiVersion = '2018-03-01',
        [Switch]
        $MultipleResource,
        [switch]
        $Disabled
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm Application Insights metric alert")) {

        $ResourceType = "Microsoft.Insights/metricAlerts"

        $WindowSize = "PT$WindowSizeInMinutes" + "M"
        $EvaluationFrequency = "PT$EvaluationFrequencyInMinutes" + "M"
        $ODataType = If ($MultipleResource.ToBool() -eq $false) {
            "Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria"
        }
        Else {
            "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
        }

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
                scopes              = $Scopes
                evaluationFrequency = $EvaluationFrequency
                windowSize          = $WindowSize
                criteria            = @{
                    "odata.type" = $ODataType
                    allOf        = @()
                }
                actions             = @()
            }
            dependsOn   = @()
        }

        $ApplicationInsightsMetricAlert.PSTypeNames.Add("ArmResource")
        return $ApplicationInsightsMetricAlert
    }
}
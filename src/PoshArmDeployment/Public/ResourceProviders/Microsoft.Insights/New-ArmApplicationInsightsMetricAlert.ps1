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
        [switch]
        $Disabled,
        [string]
        $Operator,
        [int]
        $Threshold,
        [string]
        $TimeAggregation,
        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $FailedLocationCount,
        [ValidateRange(5, 1440)]
        [int]
        $WindowSizeInMinutes = 5,
        [PSCustomObject]
        $DataSource = @{ },
        [ValidateRange(0, 4)]
        [int]
        $Severity = 3,
        [ValidateRange(1, 60)]
        [int]
        $EvaluationFrequencyInMinutes = 1

    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm Application Insights metric alert")) {

        Set-Variable ResourceType -option Constant -value "Microsoft.Insights/metricAlerts"

        $windowSize = "PT$WindowSizeInMinutes" + "M"
        $evaluationFrequency = "PT$EvaluationFrequencyInMinutes" + "M"

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
                scopes              = @($DataSource.WebTestResourceId.ToString(),
                    $DataSource.ApplicationInsightsResourceId.ToString()
                )
                evaluationFrequency = $evaluationFrequency
                windowSize          = $windowSize
                criteria            = [PSCustomObject]@{
                    "odata.type"        = "Microsoft.Azure.Monitor.WebtestLocationAvailabilityCriteria"
                    webTestId           = $DataSource.WebTestResourceId.ToString()
                    componentId         = $DataSource.ApplicationInsightsResourceId.ToString()
                    failedLocationCount = 3

                }
                actions             = @([PSCustomObject]@{
                        actionGroupId = $DataSource.ActionGroupResourceId
                    })
            }
            dependsOn   = @($DataSource.WebTestResourceId.ToString(),
                $DataSource.ApplicationInsightsResourceId.ToString(),
                $DataSource.ActionGroupResourceId.ToString())
        }

        $ApplicationInsightsMetricAlert.PSTypeNames.Add("ArmResource")
        return $ApplicationInsightsMetricAlert
    }
}
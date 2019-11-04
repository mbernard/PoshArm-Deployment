# https://docs.microsoft.com/bs-cyrl-ba/azure/azure-monitor/app/proactive-arm-config#failure-anomalies-v2-non-classic-alert-rule
function New-ArmApplicationInsightsSmartDetectorAlertRule {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsSmartDetectorAlertRule")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]
        $Name,
        [PSTypeName("ApplicationInsights")]
        [Parameter(Mandatory)]
        $ApplicationInsights,
        [string]
        $ApiVersion = '2019-03-01',
        [int]
        $EvaluationFrequencyInMinutes = 1,
        [switch]
        $Disabled,
        [ValidateRange(0, 4)]
        [int]
        $Severity = 3
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm Application Insights resource")) {
        $ResourceType = "Microsoft.AlertsManagement/smartDetectorAlertRules"
        $EvaluationFrequency = "PT${EvaluationFrequencyInMinutes}M"

        if (-not $Disabled.ToBool()) {
            $State = "Enabled"
        }
        else {
            $State = "Disabled"
        }

        $ApplicationInsightsResourceId = $ApplicationInsights._ResourceId

        $ApplicationInsightsSmartDetectionRule = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType $ResourceType
            PSTypeName  = "ApplicationInsightsSmartDetectorAlertRule"
            type        = $ResourceType
            name        = $Name
            apiVersion  = $ApiVersion
            location    = 'global'
            properties  = @{
                description  = "Detects a spike in the failure rate of requests or dependencies"
                state        = $State
                severity     = $Severity
                frequency    = $EvaluationFrequency
                detector     = [PSCustomObject]@{
                    id = "FailureAnomaliesDetector"
                }
                scope        = @($ApplicationInsightsResourceId)
                actionGroups = [PSCustomObject]@{
                    groupIds = @()
                }
            }
            dependsOn   = @()
        }

        $ApplicationInsightsSmartDetectionRule.PSTypeNames.Add("ArmResource")
        $ApplicationInsightsSmartDetectionRule | Add-ArmDependencyOn -Dependency $ApplicationInsights
        return $ApplicationInsightsSmartDetectionRule
    }
}
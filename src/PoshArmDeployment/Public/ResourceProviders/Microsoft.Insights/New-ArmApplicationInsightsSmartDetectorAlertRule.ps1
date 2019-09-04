# https://docs.microsoft.com/bs-cyrl-ba/azure/azure-monitor/app/proactive-arm-config#failure-anomalies-v2-non-classic-alert-rule
function New-ArmApplicationInsightsSmartDetectorAlertRule {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsSmartDetectorAlertRules")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]
        $NameEnding,
        [Parameter(Mandatory)]
        [PSCustomObject]
        $DataSource
    )

    Set-Variable ResourceType -option Constant -value "Microsoft.AlertsManagement/smartDetectorAlertRules"
    Set-Variable Name -option Constant -value "Failure Anomalies - $NameEnding"

    $evaluationFrequency = if ($null -eq $DataSource.evaluationFrequencyInMinutes) { "PT1M" } else { "PT${$DataSource.evaluationFrequencyInMinutes}M" }

    If ($PSCmdlet.ShouldProcess("Creates a new Arm Application Insights resource")) {
        $ApplicationInsightsSmartDetectionRule = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType $ResourceType
            PSTypeName  = "ApplicationInsightsSmartDetectorAlertRules"
            type        = $ResourceType
            name        = $Name
            apiVersion  = '2019-03-01'
            location    = 'global'
            properties  = @{
                description  = "Detects a spike in the failure rate of requests or dependencies"
                state        = if ($null -eq $DataSource.state) { "Enabled" } else { $DataSource.state }
                severity     = if ($null -eq $DataSource.severity) { 3 } else { $DataSource.severity }
                frequency    = $evaluationFrequency
                detector     = [PSCustomObject]@{
                    id = "FailureAnomaliesDetector"
                }
                scope        = @(
                    $DataSource.ApplicationInsightsResourceId.ToString()
                )
                actionGroups = [PSCustomObject]@{
                    groupIds = $DataSource.ActionGroupResourceIds
                }
            }
        }

        $ApplicationInsightsSmartDetectionRule.PSTypeNames.Add("ArmResource")
        return $ApplicationInsightsSmartDetectionRule
    }
}
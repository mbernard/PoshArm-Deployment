# https://docs.microsoft.com/bs-cyrl-ba/azure/azure-monitor/app/proactive-arm-config#failure-anomalies-v2-non-classic-alert-rule
function New-ArmApplicationInsightsSmartDetectionRule {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsSmartDetectorAlertRules")]
    Param(
        # [Parameter(Mandatory, ValueFromPipeline)]
        # [Parameter(Mandatory)]
        [string]
        $Name = "Failure Anomalies - ai-bumt3j5t63e7c",
        [Parameter(Mandatory)]
        [PSCustomObject]
        $DataSource = @{ }
    )
    If ($PSCmdlet.ShouldProcess("Creates a new Arm Application Insights resource")) {
        $ApplicationInsightsSmartDetectionRule = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType 'microsoft.alertsmanagement/smartdetectoralertrules'
            PSTypeName  = "ApplicationInsightsSmartDetectorAlertRules"
            type        = 'microsoft.alertsmanagement/smartdetectoralertrules'
            name        = $Name
            apiVersion  = '2019-03-01'
            location    = 'global'
            properties  = @{
                description  = "Detects a spike in the failure rate of requests or dependencies"
                state        = "Enabled"
                severity     = 2
                frequency    = "PT1M"
                detector     = [PSCustomObject]@{
                    id = "FailureAnomaliesDetector"
                }
                scope        = @($DataSource.ApplicationInsightsResourceId.ToString())
                actionGroups = [PSCustomObject]@{
                    groupIds = $DataSource.ActionGroupResourceIds
                }
            }
        }

        $ApplicationInsightsSmartDetectionRule.PSTypeNames.Add("ArmResource")
        return $ApplicationInsightsSmartDetectionRule
    }
}
function Add-ArmApplicationInsightsMetricAlertWebTestCriteria {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsMetricAlert")]
    Param(
        [PSTypeName("ApplicationInsightsMetricAlert")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $MetricAlert,
        [PSTypeName("ApplicationInsights")]
        [Parameter(Mandatory)]
        $ApplicationInsights,
        [PSTypeName("ApplicationInsightsWebTest")]
        [Parameter(Mandatory)]
        $WebTest,
        [int]
        $FailedLocationCount = 1
    )

    If ($PSCmdlet.ShouldProcess("Adding Web Test criteria to Application Insights Metric Alert")) {
        $ApplicationInsightsResourceId = $ApplicationInsights._ResourceId
        $WebTestResourceId = $WebTest._ResourceId

        $MetricAlert.properties.criteria = [PSCustomObject]@{
            "odata.type"        = "Microsoft.Azure.Monitor.WebtestLocationAvailabilityCriteria"
            webTestId           = $WebTestResourceId
            componentId         = $ApplicationInsightsResourceId
            failedLocationCount = $FailedLocationCount
        }

        $MetricAlert.properties.scopes += $ApplicationInsightsResourceId
        $MetricAlert.properties.scopes += $WebTestResourceId

        $MetricAlert | Add-ArmDependencyOn -Dependency $ApplicationInsights -PassThru `
        | Add-ArmDependencyOn -Dependency $WebTest
    }

    return $MetricAlert
}
function New-ArmApplicationInsightsWebTest {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationInsightsWebTest")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^[a-zA-Z0-9-]*$')]
        [string]
        $Name,
        [Parameter(Mandatory)]
        [PSTypeName("ApplicationInsights")]
        $ApplicationInsights,
        [int]
        [ValidateSet(300, 600, 900)]
        $FrequencyInSeconds = 300,
        [int]
        [ValidateSet(30, 60, 90, 120)]
        $TimeoutInSeconds = 30,
        [string]
        [ValidateSet("ping")]
        $Kind = "ping",
        [switch]
        $DisableRetry,
        [string[]]
        [Parameter(Mandatory)]
        [ValidateSet("emea-nl-ams-azr", "us-ca-sjc-azr", "emea-ru-msa-edge", "emea-se-sto-edge", "apac-sg-sin-azr", "us-tx-sn1-azr", "us-il-ch1-azr", "emea-gb-db3-azr", "apac-jp-kaw-edge", "emea-ch-zrh-edge", "emea-fr-pra-edge", "us-va-ash-azr", "apac-hk-hkn-azr", "us-fl-mia-edge", "latam-br-gru-edge", "emea-au-syd-edge")]
        $LocationIds,
        [string]
        [Parameter(Mandatory)]
        $Url,
        [switch]
        $ParseDependentRequests,
        [switch]
        $DisableFollowRedirects,
        [int]
        [ValidateRange(200, 500)]
        $ExpectedHttpStatusCode = 200,
        [string]
        $ExpectedResponseUrl = ""
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Application Insights Web Test")) {
        $ApplicationInsightsResourceId = $ApplicationInsights._ResourceId.Replace('[', '').Replace(']', '')
        $ApplicationInsightsName = $ApplicationInsights.name
        $WebTestId = [GUID]::NewGuid().ToString()
        $WebRequestId = [GUID]::NewGuid().ToString()
        $ResourceName = "[concat('$Name', '-', $ApplicationInsightsName)]"
        $ApplicationInsightsWebTest = [PSCustomObject][ordered]@{
            _ResourceId = $ResourceName | New-ArmFunctionResourceId -ResourceType 'microsoft.insights/webtests'
            PSTypeName  = "ApplicationInsightsWebTest"
            type        = 'microsoft.insights/webtests'
            name        = $ResourceName
            apiVersion  = $ApplicationInsights.apiVersion
            location    = $ApplicationInsights.location
            kind        = "other"
            tags        = @{
                "[concat('hidden-link:', $ApplicationInsightsResourceId)]" = "Resource"
            }
            properties  = @{
                SyntheticMonitorId = $ResourceName
                Name               = $Name
                Enabled            = $true
                Frequency          = $FrequencyInSeconds
                Timeout            = $TimeoutInSeconds
                Kind               = $Kind
                RetryEnabled       = -not $DisableRetry.ToBool()
                Locations          = @()
                Configuration      = @{
                    WebTest = $Null
                }
            }
            resources   = @()
            dependsOn   = @()
        }

        $ParseDependentRequestsValue = $ParseDependentRequests.ToBool()
        $FollowRedirectsValue = -not $DisableFollowRedirects.ToBool()
        $WebTestConfiguration = "<WebTest Name=\""$Name\""
                                    Id=\""$WebTestId\""
                                    Enabled=\""True\""
                                    CssProjectStructure=\""\""
                                    CssIteration=\""\""
                                    Timeout=\""$TimeoutInSeconds\""
                                    WorkItemIds=\""\""
                                    xmlns=\""http://microsoft.com/schemas/VisualStudio/TeamTest/2010\""
                                    Description=\""\""
                                    CredentialUserName=\""\""
                                    CredentialPassword=\""\""
                                    PreAuthenticate=\""True\""
                                    Proxy=\""default\""
                                    StopOnError=\""False\""
                                    RecordedResultFile=\""\""
                                    ResultsLocale=\""\"">
                                    <Items>
                                        <Request Method=\""GET\""
                                            Guid=\""$WebRequestId\""
                                            Version=\""1.1\""
                                            Url=\""$Url\""
                                            ThinkTime=\""0\""
                                            Timeout=\""$TimeoutInSeconds\""
                                            ParseDependentRequests=\""$ParseDependentRequestsValue\""
                                            FollowRedirects=\""$FollowRedirectsValue\""
                                            RecordResult=\""True\""
                                            Cache=\""False\""
                                            ResponseTimeGoal=\""0\""
                                            Encoding=\""utf-8\""
                                            ExpectedHttpStatusCode=\""$ExpectedHttpStatusCode\""
                                            ExpectedResponseUrl=\""$ExpectedResponseUrl\""
                                            ReportingName=\""\""
                                            IgnoreHttpStatusCode=\""False\"" />
                                    </Items>
                                </WebTest>"

        $WebTestConfiguration = $WebTestConfiguration.Replace("`r", "").Replace("`n", "")
        $ApplicationInsightsWebTest.properties.Configuration.WebTest = $WebTestConfiguration

        foreach ($location in $LocationIds) {
            $ApplicationInsightsWebTest.properties.Locations += @{
                Id = $location
            }
        }

        $ApplicationInsightsWebTest.PSTypeNames.Add("ArmResource")
        $ApplicationInsightsWebTest | Add-ArmDependencyOn -Dependency $ApplicationInsights
        return $ApplicationInsightsWebTest
    }
}
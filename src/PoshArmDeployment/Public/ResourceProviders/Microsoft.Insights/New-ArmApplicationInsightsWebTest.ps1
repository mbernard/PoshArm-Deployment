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
        $Frequency = 300,
        [int]
        [ValidateSet(30, 60, 90, 120)]
        $Timeout = 30,
        [string]
        [ValidateSet("ping")]
        $Kind = "ping",
        [bool]
        $RetryEnabled = $True,
        [string[]]
        [Parameter(Mandatory)]
        [ValidateSet("emea-nl-ams-azr", "us-ca-sjc-azr", "emea-ru-msa-edge", "emea-se-sto-edge", "apac-sg-sin-azr", "us-tx-sn1-azr", "us-il-ch1-azr", "emea-gb-db3-azr", "apac-jp-kaw-edge", "emea-ch-zrh-edge", "emea-fr-pra-edge", "us-va-ash-azr", "apac-hk-hkn-azr", "us-fl-mia-edge", "latam-br-gru-edge", "emea-au-syd-edge")]
        $Locations,
        [string]
        [Parameter(Mandatory)]
        $Url,
        [bool]
        $ParseDependentRequests = $False,
        [bool]
        $FollowRedirects = $True,
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
        $ApplicationInsightsWebTest = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType 'microsoft.insights/webtests'
            PSTypeName  = "ApplicationInsightsWebTest"
            type        = 'microsoft.insights/webtests'
            name        = "[concat('$Name', '-', $ApplicationInsightsName)]"
            apiVersion  = $ApplicationInsights.apiVersion
            location    = $ApplicationInsights.location
            kind        = "other"
            tags        = @{
                "[concat('hidden-link:', $ApplicationInsightsResourceId)]" = "Resource"
            }
            properties  = @{
                SyntheticMonitorId = "[concat('$Name', '-', $ApplicationInsightsName)]"
                Name               = $Name
                Enabled            = $true
                Frequency          = $Frequency
                Timeout            = $Timeout
                Kind               = $Kind
                RetryEnabled       = $RetryEnabled
                Locations          = @()
                Configuration      = @{
                    WebTest = $Null
                }
            }
            resources   = @()
            dependsOn   = @()
        }

        $WebTestConfiguration = "<WebTest Name=\""$Name\""
                                    Id=\""$WebTestId\""
                                    Enabled=\""True\""
                                    CssProjectStructure=\""\""
                                    CssIteration=\""\""
                                    Timeout=\""$Timeout\""
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
                                            Timeout=\""$Timeout\""
                                            ParseDependentRequests=\""$ParseDependentRequests\""
                                            FollowRedirects=\""$FollowRedirects\""
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

        foreach ($location in $Locations) {
            $ApplicationInsightsWebTest.properties.Locations += @{
                Id = $location
            }
        }

        $ApplicationInsightsWebTest.PSTypeNames.Add("ArmResource")
        return $ApplicationInsightsWebTest
    }
}
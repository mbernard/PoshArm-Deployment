function Add-ArmApplicationGatewayHealthProbe {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationGateway")]
    Param(
        [PSTypeName("ApplicationGateway")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $ApplicationGateway,
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-_.]*)$')]
        [string]
        $Name = "default",
        [string]
        [ValidateSet("Http", "Https")]
        $Protocol = "Http",
        [string]
        $HostName,
        [string]
        $Path = "/",
        [int]
        $IntervalInSeconds = 30,
        [int]
        $TimeoutInSeconds = 30,
        [int]
        $UnhealthyThreshold = 3,
        [switch]
        $PickHostNameFromBackendHttpSettings,
        [int]
        $MinServers = 0,
        [PSCustomObject]
        $Match = @{ }
    )

    If ($PSCmdlet.ShouldProcess("Adding Health Probe")) {
        $Properties = [PSCustomObject]@{
            protocol                            = $Protocol
            path                                = $Path
            interval                            = $IntervalInSeconds
            timeout                             = $TimeoutInSeconds
            unhealthyThreshold                  = $UnhealthyThreshold
            pickHostNameFromBackendHttpSettings = $PickHostNameFromBackendHttpSettings.ToBool()
            minServers                          = $MinServers
            match                               = $Match
            host                                = $Hostname
        }

        $probe = [PSCustomObject][ordered]@{
            type       = 'Microsoft.Network/applicationGateways/probes'
            name       = $Name
            properties = $Properties
        }

        $ApplicationGateway.properties.probes += $probe

        return $ApplicationGateway
    }
}
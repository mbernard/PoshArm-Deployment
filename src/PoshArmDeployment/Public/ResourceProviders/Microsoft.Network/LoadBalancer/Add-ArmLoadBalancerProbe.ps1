function Add-ArmLoadBalancerProbe {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("LoadBalancer")]
    Param(
        [PSTypeName("LoadBalancer")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $LoadBalancer,
        [string]
        $Name = "default",
        [int]
        $IntervalInSeconds = 5,
        [int]
        $NumberOfProbes = 2,
        [int]
        [Parameter(Mandatory)]
        $Port,
        [string]
        [ValidateSet("Http", "Tcp")]
        $Protocol = "Tcp"
    )

    If ($PSCmdlet.ShouldProcess("Adding probe")) {
        $LoadBalancerResourceId = $LoadBalancer._ResourceId

        $Probe = [PSCustomObject][Ordered]@{
            _ResourceId = "[concat($LoadBalancerResourceId, '/probes/', '$Name')]"
            name = $Name
            properties = @{
                intervalInSeconds = $IntervalInSeconds
                numberOfProbes = $NumberOfProbes
                port = $Port
                protocol = $Protocol
            }
        }

        $LoadBalancer.properties.probes += $Probe

        return $LoadBalancer
    }
}
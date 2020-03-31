function Add-ArmServiceFabricNodeType {
    [CmdletBinding(SupportsShouldProcess = $True)]
    [OutputType("ServiceFabricCluster")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [PSTypeName("ServiceFabricCluster")]
        $ServiceFabricCluster,
        [ValidatePattern('^[a-zA-Z0-9]*$')]
        [string]
        $Name = "default",
        [string]
        $Location = $script:location,
        [string]
        $DurabilityLevel = "Bronze",
        [int]
        $InstanceCount = 5,
        [Switch]
        $IsPrimary
    )
    If ($PSCmdlet.ShouldProcess("Creates a new service fabric node type object")) {
        $nodeType = [PSCustomObject][ordered]@{
            PSTypeName                   = "ServiceFabricNodeType"
            name                         = $Name
            applicationPorts             = @{
                endPort   = 30000
                startPort = 20000
            }
            clientConnectionEndpointPort = 19000
            durabilityLevel              = $DurabilityLevel
            ephemeralPorts               = @{
                endPort   = 65534
                startPort = 49152
            }
            httpGatewayEndpointPort      = 19080
            isPrimary                    = $IsPrimary.ToBool()
            vmInstanceCount              = $InstanceCount
            _ServiceFabricCluster        = $ServiceFabricCluster
        }

        $ServiceFabricCluster.properties.nodeTypes += $nodeType

        return $ServiceFabricCluster
    }
}
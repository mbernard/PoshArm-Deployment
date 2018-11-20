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
        $CertificateThumbprint,
        [string]
        $DurabilityLevel = "Bronze",
        [string]
        [Parameter(Mandatory)]
        $AdminUserName,
        [string]
        [Parameter(Mandatory)]
        $AdminPassword,
        [PSTypeName("Subnet")]
        [Parameter(Mandatory)]
        $Subnet
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
            isPrimary                    = $true
            vmInstanceCount              = 5
            _ServiceFabricCluster        = $ServiceFabricCluster
        }

        $ServiceFabricCluster.properties.nodeTypes += $nodeType

        New-ArmResourceName Microsoft.Compute/virtualMachineScaleSets -ResourceName $Name `
            | New-ArmVirtualMachineScaleSetResource `
            | Add-ArmStorageProfile `
            | Add-ArmOsProfile -AdminUserName $AdminUserName -AdminPassword $AdminPassword `
            | Add-ArmNetworkProfile -Subnet $subnet `
            | Add-ArmServiceFabricExtension -NodeType $nodeType `
            | Add-ArmResourceToTemplate

        return $ServiceFabricCluster
    }
}
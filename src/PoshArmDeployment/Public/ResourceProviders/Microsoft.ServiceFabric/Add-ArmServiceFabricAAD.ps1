function Add-ArmServiceFabricAAD {
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param(
        [PSTypeName("ServiceFabricCluster")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $ServiceFabricCluster,
        [string]
        $TenantId,
        [string]
        [Parameter(Mandatory)]
        $ClusterApplicationId,
        [string]
        [Parameter(Mandatory)]
        $ClientApplicationId
    )

    Begin {
        if (!$TenantId) {
            $TenantId = '[subscription().tenantId]'
        }
    }

    Process {
        If ($PSCmdlet.ShouldProcess("Adding AAD auth to service fabric cluster")) {
            $ServiceFabricCluster.properties.azureActiveDirectory = @{
                tenantId           = $TenantId
                clusterApplication = $ClusterApplicationId
                clientApplication  = $ClientApplicationId
            }
        }

        return $ServiceFabricCluster
    }
}
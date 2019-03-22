function New-ArmSignalRServiceResource {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("SignalRService")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name,
        [string]
        $ApiVersion = '2018-10-01',
        [string]
        $Location = $script:Location,
        [string]
        [ValidateSet("Free_F1", "Standard_S1")]
        $SkuName = 'Free_F1',
        [string]
        [ValidateSet("Free", "Standard", "Premium")]
        $SkuTier = 'Free',
        [int]
        $Capacity = 1
    )

    If ($PSCmdlet.ShouldProcess("Creates a new SignalR service resource")) {
        $ApplicationInsights = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType 'Microsoft.SignalRService/SignalR'
            PSTypeName  = "SignalRService"
            type        = 'Microsoft.SignalRService/SignalR'
            name        = $Name
            apiVersion  = $ApiVersion
            location    = $Location
            properties  = @{
                domainLabel = $Name
            }
            sku         = @{
                name     = $SkuName
                tier     = $SkuTier
                capacity = $Capacity
            }
            resources   = @()
            dependsOn   = @()
        }

        $ApplicationInsights.PSTypeNames.Add("ArmResource")
        return $ApplicationInsights
    }
}
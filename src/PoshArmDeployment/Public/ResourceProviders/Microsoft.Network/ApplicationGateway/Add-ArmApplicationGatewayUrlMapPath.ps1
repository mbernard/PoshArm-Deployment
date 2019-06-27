function Add-ArmApplicationGatewayUrlMapPath {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationGateway")]
    Param(
        [PSTypeName("ApplicationGateway")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $ApplicationGateway,
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        [Parameter(Mandatory)]
        $Name,
        [Parameter(Mandatory)]
        [string]
        $BackendAddressPoolName,
        [Parameter(Mandatory)]
        [string]
        $BackendHttpSettingsName,
        [Parameter(Mandatory)]
        [string[]]
        $Paths,
        [string]
        [Parameter(Mandatory)]
        $MapName
    )

    If ($PSCmdlet.ShouldProcess("Adding new Url path to map")) {
        $ApplicationGatewayResourceId = $ApplicationGateway._ResourceId
        $PathRule = @{
            name       = $Name
            properties = @{
                paths               = $Paths
                backendAddressPool  = @{
                    id = "[concat($ApplicationGatewayResourceId, '/backendAddressPools/', '$($BackendAddressPoolName)')]" 
                }
                backendHttpSettings = @{
                    id = "[concat($ApplicationGatewayResourceId, '/backendHttpSettingsCollection/', '$($BackendHttpSettingsName)')]" 
                }
            }
        }

        $Map = $ApplicationGateway.properties.urlPathMaps | Where-Object { $_.name -Match $MapName }
        $Map[0].properties.pathRules += $PathRule
        
        return $ApplicationGateway
    }
}
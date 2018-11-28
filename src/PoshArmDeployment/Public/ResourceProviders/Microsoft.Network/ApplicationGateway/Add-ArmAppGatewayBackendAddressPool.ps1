function Add-ArmAppGatewayBackendAddressPool {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationGateway")]
    Param(
        [PSTypeName("ApplicationGateway")]
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "ApplicationGateway")]
        $AppGateway,
        [string]
        [Parameter(Mandatory)]
        $Name,
        [Parameter(Mandatory)]
        [PSTypeName("NetworkInterfaceConfiguration")]
        $Nic
    )

    If ($PSCmdlet.ShouldProcess("Adding backend pool")) {
        $Nic.properties.ipConfigurations[0].properties.applicationGatewayBackendAddressPools += @{
            id = $backendPool._ResourceId
        }

        return $AppGateway
    }
}
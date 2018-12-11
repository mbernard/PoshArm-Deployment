function Add-ArmApplicationGatewayBackendAddressPool {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ApplicationGateway")]
    Param(
        [PSTypeName("ApplicationGateway")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $ApplicationGateway,
        [string]
        $Name = "default"
    )

    If ($PSCmdlet.ShouldProcess("Adding backend pool")) {
        $BackendAddressPool = [PSCustomObject][ordered]@{
            name        = $Name
        }

        $ApplicationGateway.properties.backendAddressPools += $BackendAddressPool

        return $ApplicationGateway
    }
}
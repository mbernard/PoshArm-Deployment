function New-ArmServiceBusResource {
    [CmdletBinding(SupportsShouldProcess = $True)]
    [OutputType("ServiceBus")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9]*)$')]
        [string]
        $Name,
        [string]
        $ApiVersion = '2017-04-01',
        [string]
        $Location = $script:Location,
        [string]
        [ValidateSet('Basic', 'Standard', 'Premium')]
        $Sku = 'Standard'
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm ServiceBus object")) {
        $ServiceBus = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType Microsoft.ServiceBus/namespaces
            PSTypeName = "ServiceBus"
            type       = 'Microsoft.ServiceBus/namespaces'
            name       = $Name
            apiVersion = $ApiVersion
            location   = $Location
            sku        = @{
                name = $Sku
                tier = "Standard"
            }
            properties = @{}
            resources  = @()
            dependsOn  = @()
        }

        $ServiceBus.PSTypeNames.Add("ArmResource")
        return $ServiceBus
    }
}
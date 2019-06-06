function New-ArmCosmosDbAccount {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("CosmosDbAccount")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]{3,50})$')]
        [string]
        $Name,
        [ValidateSet('GlobalDocumentDB', 'MongoDB', 'Parse')]
        [string]
        $Kind = 'GlobalDocumentDB',
        [ValidateSet('EnableCassandra', 'EnableTable', 'EnableGremlin')]
        [string]
        $Capability,
        [switch]
        $EnableMultipleWriteLocations,
        [switch]
        $VirtualNetworkFilterEnabled,
        [string]
        [ValidatePattern('^(?:[0-9]{1,3}\.){3}[0-9]{1,3}\/[0-9]{1,2}$')]
        $IpRangeFilter = '',
        [string]
        $ApiVersion = '2016-03-31',
        [string]
        $Location = $script:Location,
        [string]
        $LocationName = $script:LocationName
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm CosmosDb account")) {
        $CosmosDbAccount = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType 'Microsoft.DocumentDb/databaseAccounts'
            PSTypeName  = "CosmosDbAccount"
            type        = 'Microsoft.DocumentDb/databaseAccounts'
            name        = $Name
            kind        = $Kind
            apiVersion  = $ApiVersion
            location    = $Location
            properties  = @{
                databaseAccountOfferType      = 'Standard'
                locations                     = @(
                    @{
                        id               = "[concat($Name, '-', '$Location')]"
                        failoverPriority = 0
                        locationName     = $LocationName
                    }
                )
                enableMultipleWriteLocations  = $EnableMultipleWriteLocations.ToBool()
                isVirtualNetworkFilterEnabled = $VirtualNetworkFilterEnabled.ToBool()
                ipRangeFilter                 = $IpRangeFilter
                virtualNetworkRules           = @()
            }
            dependsOn   = @()
        }

        if ($Capability) {
            $Capabilities = @($Capability | Select-Object -Property @{ Name = 'name'; Expression = { $_ } })
            $CosmosDbAccount.properties.capabilities = $Capabilities
        }

        $CosmosDbAccount.PSTypeNames.Add("ArmResource")
        return $CosmosDbAccount
    }
}
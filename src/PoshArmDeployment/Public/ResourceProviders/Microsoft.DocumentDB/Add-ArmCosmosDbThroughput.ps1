function Add-ArmCosmosDbThroughput {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("CosmosDbDatabaseThroughput")]
    Param(
        [Parameter(Mandatory)]
        [PSTypeName("CosmosDbAccount")]
        $CosmosDbAccount,
        [Parameter(Mandatory)]
        [string]
        $Name,
        [ValidateSet('sql', 'gremlin', 'mongodb')]
        [string]
        $DatabaseType = 'sql',
        [string]
        $ApiVersion = '2016-03-31',
        [ValidateRange(400, 1000000)]
        [string]
        $ThroughputInRU = 400
    )

    If ($PSCmdlet.ShouldProcess("Updates an new Arm CosmosDb database throughput")) {
        $AccountName = $CosmosDbAccount.Name
        $CosmosDbDatabaseThroughput = [PSCustomObject][ordered]@{
            PSTypeName  = "CosmosDbDatabaseThroughput"
            type        = 'Microsoft.DocumentDB/databaseAccounts/apis/databases/settings'
            name        = "[concat($AccountName, '/$DatabaseType/', '$Name', '/throughput')]"
            apiVersion  = $ApiVersion
            properties  = @{
                resource = @{
                    throughput = $ThroughputInRU
                }
            }
            dependsOn   = @()
        }

        $CosmosDbDatabaseThroughput.PSTypeNames.Add("ArmResource")
        return $CosmosDbDatabaseThroughput
    }
}
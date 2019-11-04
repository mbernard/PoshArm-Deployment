function New-ArmCosmosDbDatabase {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("CosmosDbDatabase")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern("^(\[.*\]|[a-zA-Z0-9-]{3,50})$")]
        [string]
        $Name,
        [Parameter(Mandatory)]
        [PSTypeName("CosmosDbAccount")]
        $CosmosDbAccount,
        [ValidateSet("sql", "gremlin", "mongodb")]
        [string]
        $DatabaseType = "sql",
        [string]
        $ApiVersion = "2016-03-31",
        [ValidateRange(400, 1000000)]
        [string]
        $ThroughputInRU = 400
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm CosmosDb database")) {
        $ResourceType = "Microsoft.DocumentDb/databaseAccounts/apis/databases"
        $AccountName = $CosmosDbAccount.Name
        $Database = [PSCustomObject][ordered]@{
            _ResourceId = New-ArmFunctionResourceId -ResourceType $ResourceType -ResourceName1 $AccountName -ResourceName2 $Name
            PSTypeName  = "CosmosDbDatabase"
            type        = $ResourceType
            name        = "[concat($AccountName, '/$DatabaseType/', '$Name')]"
            apiVersion  = $ApiVersion
            properties  = @{
                resource = @{
                    id = $Name
                }
                options  = @{
                    throughput = $ThroughputInRU
                }
            }
            dependsOn   = @()
        }

        $Database.PSTypeNames.Add("ArmResource")
        $Database | Add-ArmDependencyOn -Dependency $CosmosDbAccount

        return $Database
    }
}
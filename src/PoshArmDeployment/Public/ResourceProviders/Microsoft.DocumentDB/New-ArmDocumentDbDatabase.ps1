function New-ArmDocumentDbDatabase {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("DocumentDbDatabase")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]{3,50})$')]
        [string]
        $Name,
        [Parameter(Mandatory)]
        [PSTypeName("DocumentDbAccount")]
        $DocumentDbAccount,
        [string]
        $ApiVersion = '2016-03-31',
        [ValidateRange(400, 1000000)]
        [string]
        $Throughput = 400
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm Document DB database account")) {
        $AccountName = $DocumentDbAccount.Name
        $Database = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType 'Microsoft.DocumentDB/databaseAccounts/apis/databases'
            PSTypeName  = "DocumentDbDatabase"
            type        = 'Microsoft.DocumentDB/databaseAccounts/apis/databases'
            name        = "[concat($AccountName, '/sql/', '$Name')]"
            apiVersion  = $ApiVersion
            properties  = @{
                resource = @{
                    id = $Name
                }
                options  = @{
                    throughput = $Throughput
                }
            }
            dependsOn   = @()
        }

        $Database.PSTypeNames.Add("ArmResource")
        $Database | Add-ArmDependencyOn -Dependency $DocumentDbAccount
        return $Database
    }
}
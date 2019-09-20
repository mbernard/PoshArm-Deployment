function Add-ArmCosmosDbSettings {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("CosmosDbDatabaseSettings")]
    Param(
      [Parameter(Mandatory, ValueFromPipeline)]
      [PSTypeName("CosmosDbDatabase")]
      $CosmosDbDatabase,
      [string]
      $ApiVersion = '2016-03-31',
      [ValidateRange(400, 1000000)]
      [string]
      $ThroughputInRU = 400
    )
    If ($PSCmdlet.ShouldProcess("Updates an new Arm CosmosDb database throughput")) {
      $Name = $CosmosDbDatabase.name
      $CosmosDbDatabaseSettings = [PSCustomObject][ordered]@{
        PSTypeName = "CosmosDbDatabaseSettings"
        type       = 'Microsoft.DocumentDB/databaseAccounts/apis/databases/settings'
        name       = "[concat($Name, '/throughput')]"
        apiVersion = $ApiVersion
        properties = @{
          resource = @{
            throughput = $ThroughputInRU
          }
        }
        dependsOn  = @()
      }

      $CosmosDbDatabaseSettings.PSTypeNames.Add("ArmResource")
      $CosmosDbDatabaseSettings | Add-ArmDependencyOn -Dependency $CosmosDbDatabase 
      
      return $CosmosDbDatabaseSettings
    }
  }
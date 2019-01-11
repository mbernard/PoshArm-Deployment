#Requires -Version 3.0

function New-ArmStorageResource {
    [CmdletBinding(SupportsShouldProcess = $True)]
    [OutputType("StorageAccount")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9]*)$')]
        [string]
        $Name,
        [string]
        $ApiVersion = '2018-07-01',
        [string]
        $Location = $script:Location,
        [string]
        [ValidateSet('Standard_LRS', 'Standard_GRS', 'Standard_RAGRS')]
        $Sku = 'Standard_LRS',
        [String]
        [ValidateSet('Storage', 'StorageV2')]
        $Kind = 'StorageV2',
        [string]
        [ValidateSet("Hot", "Cool")]
        $AccessTier = "Hot"

    )
    If ($PSCmdlet.ShouldProcess("Creates a new ArmStorageAccount object")) {
        $storageAccount = [PSCustomObject][ordered]@{
            PSTypeName = "StorageAccount"
            type       = 'Microsoft.Storage/storageAccounts'
            name       = $Name
            apiVersion = $ApiVersion
            location   = $Location
            sku        = @{
                name = $Sku
                tier = "Standard"
            }
            kind       = $Kind
            properties = @{
                supportsHttpsTrafficOnly = $true
                encryption               = @{
                    services  = @{
                        file = @{
                            enabled = $true
                        }
                        blob = @{
                            enabled = $true
                        }
                    }
                    keySource = "Microsoft.Storage"
                }
                accessTier               = $AccessTier
            }
            resources  = @()
            dependsOn  = @()
        }

        $storageAccount.PSTypeNames.Add("ArmResource")
        return $storageAccount
    }
}
#Requires -Version 3.0

function New-ArmStorageResource {
    [CmdletBinding(SupportsShouldProcess = $True)]
    [OutputType([hashtable])]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^[a-zA-Z0-9]*$')]
        [string]
        $Name,
        [string]
        $ApiVersion = '2017-10-01',
        [string]
        $Location = $script:location,
        [string]
        [ValidateSet('Standard_LRS', 'Standard_GRS', 'Standard_RAGRS')]
        $Sku = 'Standard_LRS',
        [String]
        [ValidateSet('Storage', 'StorageV2')]
        $Kind = 'StorageV2'

    )
    If ($PSCmdlet.ShouldProcess("Creates a new ArmStorageAccount object")) {
        return [PSCustomObject][ordered]@{
            PSTypeName = "ARMresource"
            type       = 'Microsoft.Storage/storageAccounts'
            name       = $Name
            apiVersion = $ApiVersion
            location   = $Location
            sku        = @{
                name = $Sku
            }
            kind       = $Kind
            properties = @{}
            resources  = @()
            dependsOn  = @()
        }
    }
}
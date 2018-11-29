function New-ArmVirtualMachineScaleSetResource {
    [CmdletBinding(SupportsShouldProcess = $True)]
    [OutputType("VirtualMachineScaleSet")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name,
        [string]
        $ApiVersion = "2017-12-01",
        [string]
        $Location = $script:Location,
        $Sku = "Standard_D1_v2",
        [int]
        $Capacity = 5,
        [string]
        [ValidateSet("Automatic", "Manual")]
        $UpgradeMode = "Automatic"
    )
    If ($PSCmdlet.ShouldProcess("Creates a new Arm Virtual Machine Scale Set object")) {
        $vmss = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType Microsoft.Compute/virtualMachineScaleSets
            PSTypeName  = "VirtualMachineScaleSet"
            type        = 'Microsoft.Compute/virtualMachineScaleSets'
            name        = $Name
            apiVersion  = $ApiVersion
            location    = $Location
            sku         = @{
                name     = $Sku
                tier     = "Standard"
                capacity = $Capacity
            }
            identity    = @{
                type = "SystemAssigned"
            }
            properties  = @{
                overprovision = $false
                upgradePolicy         = @{
                    mode = $UpgradeMode
                }
                virtualMachineProfile = @{
                    storageProfile     = @{}
                    osProfile          = @{}
                    networkProfile     = @{
                        networkInterfaceConfigurations = @()
                    }
                    diagnosticsProfile = @{}
                    extensionProfile   = @{
                        extensions = @()
                    }
                }
            }
            resources   = @()
            dependsOn   = @()
        }

        $vmss.PSTypeNames.Add("ArmResource")
        return $vmss
    }
}
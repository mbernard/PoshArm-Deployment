function New-ArmLogAnalyticsWorkspace {
    [CmdletBinding(SupportsShouldProcess = $True)]
    [OutputType("LogAnalyticsWorkspace")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9][a-zA-Z0-9\-]{2,61}[a-zA-Z0-9])$')]
        [string]
        $Name,
        [string]
        $ApiVersion = '2015-11-01-preview',
        [string]
        $Location = $script:Location,
        [string]
        [ValidateSet('Free', 'Standard', 'Premium', 'Unlimited', 'PerNode', 'PerGB2018', 'Standalone')]
        $Sku = 'Free',
        [int]
        [ValidateRange(-1, 730)]
        $RetentionInDays = 30
    )

    If ($PSCmdlet.ShouldProcess("Creates a new log analytics workspace object")) {
        $logAnalyticsWorkspace = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType Microsoft.OperationalInsights/workspaces
            PSTypeName  = "LogAnalyticsWorkspace"
            type        = 'Microsoft.OperationalInsights/workspaces'
            name        = $Name
            apiVersion  = $ApiVersion
            location    = $Location
            properties  = @{
                sku             = @{
                    name = $Sku
                }
                retentionInDays = $RetentionInDays
            }
            resources   = @()
            dependsOn   = @()
        }

        $logAnalyticsWorkspace.PSTypeNames.Add("ArmResource")
        return $logAnalyticsWorkspace
    }
}
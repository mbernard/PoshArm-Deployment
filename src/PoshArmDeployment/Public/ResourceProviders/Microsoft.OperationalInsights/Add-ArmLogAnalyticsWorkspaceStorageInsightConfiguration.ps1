function Add-ArmLogAnalyticsWorkspaceStorageInsightConfiguration {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("LogAnalyticsWorkspace")]
    Param(
        [PSTypeName("LogAnalyticsWorkspace")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $LogAnalyticsWorkspace,
        [Parameter(Mandatory)]
        [PSTypeName("StorageAccount")]
        $StorageAccount,
        [string[]]
        $Containers = @(),
        [string[]]
        $Tables = @()
    )

    If ($PSCmdlet.ShouldProcess("Adding Storage Account to Log Analytics Workspace")) {
        $StorageAccountName = $StorageAccount.name
        $StorageAccountResourceId = $StorageAccount._ResourceId
        $LogAnalyticsWorkspaceName = $LogAnalyticsWorkspace.name
        $StorageInsightConfiguration = @{
            apiVersion = $LogAnalyticsWorkspace.apiVersion
            name       = "[concat($StorageAccountName, $LogAnalyticsWorkspaceName)]"
            type       = "storageinsightconfigs"
            properties = @{
                containers     = $Containers
                tables         = $Tables
                storageAccount = @{
                    id  = $StorageAccountResourceId
                    key = "[listKeys($StorageAccountResourceId, '2015-05-01-preview').key1]"
                }
            }
            dependsOn  = @()
        }

        $StorageInsightConfiguration.PSTypeNames.Add("ArmResource")
        $StorageInsightConfiguration | Add-ArmDependencyOn -Dependency $LogAnalyticsWorkspace
        $LogAnalyticsWorkspace.resources += $StorageInsightConfiguration

        return $LogAnalyticsWorkspace
    }
}
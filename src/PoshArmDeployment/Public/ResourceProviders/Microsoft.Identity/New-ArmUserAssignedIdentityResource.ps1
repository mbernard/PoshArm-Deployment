function New-ArmUserAssignedIdentityResource {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("UserAssignedIdentity")]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^(\[.*\]|[a-zA-Z0-9-]*)$')]
        [string]
        $Name,
        [string]
        $ApiVersion = '2015-08-31-PREVIEW',
        [string]
        $Location = $script:Location
    )

    If ($PSCmdlet.ShouldProcess("Creates a new Arm user assigned identity object")) {
        $userAssignedIdentity = [PSCustomObject][ordered]@{
            _ResourceId = $Name | New-ArmFunctionResourceId -ResourceType 'Microsoft.ManagedIdentity/userAssignedIdentities'
            PSTypeName  = "UserAssignedIdentity"
            type        = 'Microsoft.ManagedIdentity/userAssignedIdentities'
            name        = $Name
            apiVersion  = $ApiVersion
            location    = $Location
            resources   = @()
            dependsOn   = @()
        }

        $userAssignedIdentity.PSTypeNames.Add("ArmResource")
        return $userAssignedIdentity
    }
}
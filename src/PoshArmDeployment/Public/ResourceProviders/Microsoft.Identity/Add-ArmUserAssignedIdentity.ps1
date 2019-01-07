function Add-ArmUserAssignedIdentity {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("ArmResource")]
    Param(
        [PSTypeName("ArmResource")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $ArmResource,
        [string]
        $IdentityResourceId
    )

    If ($PSCmdlet.ShouldProcess("Adding identity to resource")) {
        $ArmResource | Add-Member -Type NoteProperty -Name "identity" -Value @{
            type        = "UserAssigned"
            identityIds = @(
                "$IdentityResourceId"
            )
        }

        return $ArmResource
    }
}
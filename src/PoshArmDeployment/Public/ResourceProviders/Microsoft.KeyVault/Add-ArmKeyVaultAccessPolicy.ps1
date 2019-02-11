function Add-ArmKeyVaultAccessPolicy {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType("KeyVault")]
    Param(
        [PSTypeName("KeyVault")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $KeyVault,
        [string]
        $ObjectId,
        [string[]]
        [ValidateSet(
            "encrypt",
            "decrypt",
            "wrapKey",
            "unwrapKey",
            "sign",
            "verify",
            "get",
            "list",
            "create",
            "update",
            "import",
            "delete",
            "backup",
            "restore",
            "recover",
            "purge")]
        $KeysPermissions = @(),
        [string[]]
        [ValidateSet(
            "get",
            "list",
            "set",
            "delete",
            "backup",
            "restore",
            "recover",
            "purge")]
        $SecretsPermissions = @(),
        [string[]]
        [ValidateSet(
            "get",
            "list",
            "delete",
            "create",
            "import",
            "update",
            "managecontacts",
            "getissuers",
            "listissuers",
            "setissuers",
            "deleteissuers",
            "manageissuers",
            "recover",
            "purge")]
        $CertificatesPermissions = @()
    )

    If ($PSCmdlet.ShouldProcess("Adding Key Vault access policy")) {
        $accessPolicyEntry = @{
            tenantId    = $KeyVault.properties.tenantId
            objectId    = $ObjectId
            permissions = @{
                keys         = $KeysPermissions
                secrets      = $SecretsPermissions
                certificates = $CertificatesPermissions
                storage      = @()
            }
        }

        $KeyVault.properties.accessPolicies += $accessPolicyEntry

        return $KeyVault
    }
}
function Add-ArmServiceFabricBackupService {
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param(
        [PSTypeName("ServiceFabricCluster")]
        [Parameter(Mandatory, ValueFromPipeline)]
        $ServiceFabricCluster,
        [Parameter(Mandatory)]
        [string]
        $EncryptionCertificateThumbprint
    )

    Process {
        If ($PSCmdlet.ShouldProcess("Adding Backup and Restore to service fabric cluster")) {
            $ServiceFabricCluster.properties.addonFeatures += "BackupRestoreService"
            $ServiceFabricCluster.properties.fabricSettings += @{
                parameters = @(
                    @{
                        name  = "SecretEncryptionCertThumbprint"
                        value = $EncryptionCertificateThumbprint
                    },
                    @{
                        name  = "SecretEncryptionCertX509StoreName"
                        value = "My"
                    }
                )
                name       = "BackupRestoreService"
            }
        }

        return $ServiceFabricCluster
    }
}
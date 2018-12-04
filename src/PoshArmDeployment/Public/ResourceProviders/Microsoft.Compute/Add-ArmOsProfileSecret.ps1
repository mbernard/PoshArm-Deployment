function Add-ArmOsProfileSecret {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = "vm")]
    Param(
        [PSTypeName("VirtualMachine")]
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "vm")]
        $VirtualMachine,
        [PSTypeName("VirtualMachineScaleSet")]
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "vmss")]
        $VirtualMachineScaleSet,
        [string]
        [Parameter(Mandatory)]
        $KeyVaultResourceId,
        $CertificateUrls = @()
    )

    Process {
        If ($PSCmdlet.ShouldProcess("Adding os profile secret to a virtual machine")) {
            $secret = [PSCustomObject][ordered]@{
                PSTypeName        = "Secret"
                sourceVault       = @{
                    id = $KeyVaultResourceId
                }
                vaultCertificates = @()
            }

            foreach ($Url in $CertificateUrls) {
                $secret.vaultCertificates += @{
                    certificateUrl   = $Url
                    certificateStore = "My"
                }
            }

            if ($PSCmdlet.ParameterSetName -eq "vm") {
                $VirtualMachine.properties.osProfile.secrets += $secret
                return $VirtualMachine
            }
            else {
                $VirtualMachineScaleSet.properties.virtualMachineProfile.osProfile.secrets += $secret
                return $VirtualMachineScaleSet
            }
        }
    }
}
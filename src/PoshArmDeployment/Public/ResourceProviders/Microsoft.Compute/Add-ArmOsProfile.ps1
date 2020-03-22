function Add-ArmOsProfile {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = "vm")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingUserNameAndPassWordParams", "")]
    Param(
        [PSTypeName("VirtualMachine")]
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "vm")]
        $VirtualMachine,
        [PSTypeName("VirtualMachineScaleSet")]
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "vmss")]
        $VirtualMachineScaleSet,
        [string]
        $Name = "default",
        [String]
        [Parameter(Mandatory)]
        $AdminUserName,
        [string]
        [Parameter(Mandatory)]
        $AdminPassword,
        [Switch]
        $Linux
    )

    Process {
        If ($PSCmdlet.ShouldProcess("Adding os profile to a virtual machine")) {
            $OsProfile = @{
                computerNamePrefix   = $Name
                adminUserName        = $AdminUserName
                adminPassword        = $AdminPassword
                secrets = @()
            }

            if($Linux)
            { 
                $OsProfile.linuxConfiguration= @{
                    disablePasswordAuthentication= $false
                }
            }
            else {
                $OsProfile.windowsConfiguration = @{
                    provisionVMAgent = $true
                    enableAutomaticUpdates = $true
                }
            }

            if ($PSCmdlet.ParameterSetName -eq "vm") {
                $VirtualMachine.properties.osProfile = $OsProfile
                return $VirtualMachine
            }
            else {
                $VirtualMachineScaleSet.properties.virtualMachineProfile.osProfile = $OsProfile
                return $VirtualMachineScaleSet
            }
        }
    }
}